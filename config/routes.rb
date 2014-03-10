Idealy::Application.routes.draw do
  resources :ideas

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  match("/idea", to: "ideas#idea", via: "get")
end
