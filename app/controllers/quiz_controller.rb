class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    s_file = File.read('pushkin.json')
    str = JSON.parse(s_file)
    @per = str[0][0]
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
        tmp_tmp_inp.size.times do |k|
          if tmp_tmp_inp[k].include?('WORD')
            index_a = k
          end
        end
        str.size.times do |i|
          tmp_str = str[i][1].split("\n")
          tmp_str.size.times do |j|
            tmp_tmp_str = tmp_str[j].split(' ')
            if tmp_tmp_str.size != tmp_tmp_inp.size
              next
            end
            fl = 1
            tmp_tmp_str.size.times do |k|
              if tmp_tmp_str[k] != tmp_tmp_inp[k] && !tmp_tmp_inp[k].include?('WORD')
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
      when 3
        tmp_inp_mas = question.split("\n")
        tmp_tmp_inp = tmp_inp_mas[0].split(' ')
        tmp_tmp_str = Array.new
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
              break
            end
            index_str += 1
          end
          if fl == 1
            answer = []
            (index_str..(index_str + level - 2)).each do |i|
              tmp_tmp_str = tmp_str[i]
              tmp_tmp_str = tmp_tmp_str.split(' ')
              tmp_tmp_inp = tmp_inp_mas[i - index_str]
              tmp_tmp_inp = tmp_tmp_inp.split(' ')
              tmp_tmp_str.size.times do |j|
                if tmp_tmp_str[j] != tmp_tmp_inp[j]
                  answer << tmp_tmp_str[j]
                  break
                end
              end
            end
            answer = answer.join(",")
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
    end
  end
end
