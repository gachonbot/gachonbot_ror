Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/keyboard' => 'basic#keyboard_init'
  post '/message' => 'basic#chat_control'
  
end
