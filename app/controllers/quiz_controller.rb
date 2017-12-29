class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    s_file = File.read('pushkin.json')
    str = JSON.parse(s_file)
    @per = str[0][0]
  end

  def task
    s_file = File.read('pushkin.json')
    str = JSON.parse(s_file)
    answer = ""
    question = params["question"]
    level = params["level"].to_i
    id = params["id"]
    question = question.gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\|\{\}\:\"\[\]\<\>\?\—]/,"")
    question = question.strip
    case level
      when 1
        str.map do |e|
          tmp_str = e[1].gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\|\{\}\:\"\[\]\<\>\?\—]/,"")
          if tmp_str.include?(question)
            answer = e[0]
            break
          end
        end
      when 2
        tmp_tmp_inp = question.split(' ')
        tmp_tmp_str = Array.new
        fl = 0
        str.map do |e|
          tmp_str = e[1].gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\|\{\}\:\"\[\]\<\>\?\—]/,"")
          tmp_str = tmp_str.split("\n")
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
          end
          if fl == 1
            tmp_tmp_str.size.times do |i|
              if tmp_tmp_str[i] != tmp_tmp_inp[i]
                answer = tmp_tmp_str[i]
                break
              end
            end
            break
          end
        end
      when 3
        tmp_inp_mas = question.split("\n")
        tmp_tmp_inp = tmp_inp_mas[0].split(' ')
        #tmp_tmp_inp = question.split("\n")[0].split(' ')
        tmp_tmp_str = Array.new
        fl = 0
        str.map do |e|
          tmp_str = e[1].gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\|\{\}\:\"\[\]\<\>\?\—]/,"")
          tmp_str = tmp_str.split("\n")
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
