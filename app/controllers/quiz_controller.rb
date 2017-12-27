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
		str = ""
		answer = ""
		question = params["question"]
		level = params["level"].to_i
		id = params["id"]
		#tmp_mas = []
		#tmp_mas << question
		#tmp_mas << level
		#tmp_mas << id
		question = question.gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
		question = question.strip
		#fl = 0
  	if level == 1
  		str.map do |e|
  			tmp_str = e[1].gsub!(/[\«\»\~\!\@\#\$\%\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
  			if tmp_str.include?(question)
  				answer = e[0]
  				break
  			end
				#tmp_str = e[1].split("\n")
				#tmp_str.map do |el|
				#	if el == inp_s
				#		answer = e[0]
				#		fl = 1
				#		break
				#	end
				#end
				#if fl == 1
				#	break
				#end
			end
  	end
  	file = File.open('in_data.json', 'w') do |f|
		  f.write(answer.to_json)
		end
  	uri = URI("http://pushkin.rubyroidlabs.com/quiz")
  	parameters = {
		  answer: answer,
		  token: "60ecace79d6a948133f9fbcd7a0a4df4",
		  task_id: id
		}
		Net::HTTP.post_form(uri, parameters)
  end
end
