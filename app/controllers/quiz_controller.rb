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
    check = "some word"
    question = params["question"]
    level = params["level"].to_i
    id = params["id"]
    question = question.gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
    question = question.strip
    if level == 1
      str.map do |e|
        tmp_str = e[1].gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
        if tmp_str.include?(question)
          answer = e[0].to_s
          break
        end
      end
    end
    if answer
      check = "in answer"
      uri_app = URI('http://pushkin.rubyroidlabs.com/quiz')

      parameters = {
        answer: answer,
        token: '60ecace79d6a948133f9fbcd7a0a4df4',
        task_id: id
      }
      res = Net::HTTP.post_form(uri_app, parameters)
      file = File.open('in_data.json', 'w') do |f|
        f.write(parameters)
      end
      puts res.body
    end
    #file = File.open('in_data.json', 'w') do |f|
    #  f.write(check.to_json)
    #end
  end
end
