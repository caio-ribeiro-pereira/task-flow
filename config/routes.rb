Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get "usuario" => "users#me"
    post "cadastrar" => "users#create"
    post "login" => "sessions#create"

    resources :projetos, controller: "projects"
    post "projetos/:project_id/tarefas" => "tasks#create"
    get "projetos/:project_id/tarefas" => "tasks#index"

    resources :tarefas, controller: "tasks", only: [ :update, :destroy ]
  end
end
