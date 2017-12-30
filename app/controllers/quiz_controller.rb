class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @per = 1
  end

  def task
    #s_file = File.read('pushkin.json')
    #str = JSON.parse(s_file)
    s_file = File.read('pushkin_clear.json')
    str = JSON.parse(s_file)
    answer = ""
    question = params["question"]
    level = params["level"].to_i
    id = params["id"]
    question = question.gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\|\{\}\:\"\[\]\<\>\?\—]/,"")
    question = question.strip
    file = File.open('in_data.json', 'w') do |f|
      f.write(params)
    end
    case level
      when 1
        str.size.times do |i|
          if str[i][1].include?(question)
            answer = str[i][0]
            break
          end
        end
      when 2
        tmp_tmp_inp = question.split(' ')
        index_a = 0
        tmp_tmp_inp.size.times do |i|
          if tmp_tmp_inp[i].include?('WORD')
            index_a = i
          end
        end
        fl = 0
        str.map do |e|
          tmp_str = e[1].split("\n")
          tmp_str.map do |el|
            tmp_tmp_str = el.split(' ')
            if tmp_tmp_str.size != tmp_tmp_inp.size
              next
            end
            fl = 1
            tmp_tmp_str.size.times do |i|
              if tmp_tmp_str[i] != tmp_tmp_inp[i] && !tmp_tmp_inp[i].include?('WORD')
                fl = 0
                break
              end
            end
            if fl == 1
              answer = tmp_tmp_str[index_a]
              break
            end
          end
          if fl == 1
            break
          end
        end
      when 3..4
        tmp_inp_mas = question.split("\n")
        tmp_tmp_inp = tmp_inp_mas[0].split(' ')
        index_mas = []
        tmp_inp_mas.map do |e|
          tmp_str = e.split(' ')
          tmp_str.size.times do |i|
            if tmp_str[i].include?('WORD')
              index_mas << i
            end  
          end
        end
        index_a = index_mas[0]
        fl = 0
        str.map do |e|
          tmp_str = e[1].split("\n")
          index_str = 0
          tmp_str.map do |el|
            tmp_tmp_str = el.split(' ')
            if tmp_tmp_str.size != tmp_tmp_inp.size
              next
            end
            fl = 1
            tmp_tmp_str.size.times do |i|
              if tmp_tmp_str[i] != tmp_tmp_inp[i] && !tmp_tmp_inp[i].include?('WORD')
                fl = 0
                break
              end
            end
            if fl == 1
              answer = []
              (index_str..(index_str + level - 2)).each do |i|
                answer << tmp_str[i].split(' ')[index_mas[i - index_str]]
              end
              answer = answer.join(",")
              break
            end
            index_str += 1
          end
          if fl == 1
            break
          end
        end
      when 5
        tmp_tmp_inp = question.split(' ')
        kol = 0
        str.map do |e|
          tmp_str = e[1].split("\n")
          tmp_str.map do |el|
            tmp_tmp_str = el.split(' ')
            if tmp_tmp_str.size != tmp_tmp_inp.size
              next
            end
            kol = 0
            tmp_tmp_str.size.times do |i|
              if tmp_tmp_str[i] != tmp_tmp_inp[i]
                kol += 1
              end
              if kol == 2
                break
              end
            end
            if kol == 1
              tmp_tmp_str.size.times do |i|
                if tmp_tmp_str[i] != tmp_tmp_inp[i]
                  answer = "#{tmp_tmp_str[i]},#{tmp_tmp_inp[i]}"
                  break
                end
              end
              break
            end
          end
          if kol == 1
            break
          end
        end
      when 6
        tmp_tmp_inp = question.split(' ')
        kol = 0
        str.map do |e|
          tmp_str = e[1].split("\n")
          tmp_str.map do |el|
            tmp_tmp_str = el.split(' ')
            if tmp_tmp_str.size != tmp_tmp_inp.size
              next
            end
            kol = 0
            tmp_tmp_str.size.times do |i|
              #if tmp_tmp_str[i].sum != tmp_tmp_inp[i].sum
              #  kol = 1
              #  break
              #end
            end
            if kol == 0
              answer = el
              break
            end
          end
          if kol == 0
            break
          end
        end
    end
    if answer
      uri_app = URI('http://pushkin.rubyroidlabs.com/quiz')

      parameters = {
        answer: answer,
        token: '60ecace79d6a948133f9fbcd7a0a4df4',
        task_id: id
      }
      Net::HTTP.post_form(uri_app, parameters)
      #render json: 'ok'
      #puts res.body
    end
    file = File.open('in_data.json', 'w') do |f|
      f.write(params)
      f.write(parameters)
    end
  end
end
