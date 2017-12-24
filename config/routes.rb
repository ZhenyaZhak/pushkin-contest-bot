Rails.application.routes.draw do
  #get 'quiz/quiz'

  root 'quiz#index'
  resources :quiz, only: [:index]

  post 'quiz', to: 'quiz#quiz'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
