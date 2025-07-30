Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'rpn#index'
  
  # RPN calculator routes
  get '/calculator', to: 'rpn#index'
  post '/calculate', to: 'rpn#calculate'
end