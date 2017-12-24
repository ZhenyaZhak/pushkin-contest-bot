class QuizController < ApplicationController
	APP_URI = URI("http://pushkin.rubyroidlabs.com/quiz")

	def index
	end

  def quiz
  	s_file = File.read('pushkin.json')
		str = JSON.parse(s_file)
		answer = ""
		inp_s = params[:question]
		fl = 0
  	if 1 == params[:level].to_i
  		str.map do |e|
				tmp_str = e[1].split("\n")
				tmp_str.map do |el|
					if el == inp_s
						answer = e[0]
						fl = 1
						break
					end
				end
				if fl == 1
					break
				end
			end
  		puts 'ok'
  		puts params
  	end
  	parameters = {
		  answer: answer,
		  token: "60ecace79d6a948133f9fbcd7a0a4df4",
		  task_id:  params[:id]
		}
		Net::HTTP.post_form(APP_URI, parameters)
  end
end
