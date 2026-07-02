Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "usuario" => "users#me"
    post "cadastrar" => "users#create"
    post "login" => "sessions#create"
  end
end