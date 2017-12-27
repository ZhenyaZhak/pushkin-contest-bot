Rails.application.routes.draw do
  post 'quiz', to: 'quiz#quiz'
  root 'quiz#index'
  get 'test/test'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
