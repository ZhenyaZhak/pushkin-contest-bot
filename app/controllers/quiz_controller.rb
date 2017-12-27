class QuizController < ApplicationController
	APP_URI = URI("http://pushkin.rubyroidlabs.com/quiz")

	def index
		s_file = File.read('pushkin.json')
		str = JSON.parse(s_file)
		@per = str[0][0]
	end

  def quiz
  	@per = "123"
		file = File.open('in_data.json', 'w') do |f|
		  f.write(@per.to_json)
		end
  	#s_file = File.read('pushkin.json')
		#str = JSON.parse(s_file)
		str = ""
		answer = ""
		question = params["question"]
		level = params["level"].to_i
		id = params["id"]
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
  	parameters = {
		  answer: answer,
		  token: "60ecace79d6a948133f9fbcd7a0a4df4",
		  task_id: id
		}
		Net::HTTP.post_form(APP_URI, parameters)
  end
end
