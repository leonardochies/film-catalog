require "sidekiq/web"

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|pt-BR/ do
    resources :movies do
      resources :comments, only: [ :create ]
    end
    devise_for :users

    get "up" => "rails/health#show", as: :rails_health_check

    root "movies#index"

    if Rails.env.development?
      mount LetterOpenerWeb::Engine, at: "/letter_opener"
    end

    authenticate :user do
      resources :categories, only: [ :index, :new, :create, :destroy ]
      resources :import_jobs, only: [ :index, :new, :create ]
    mount Sidekiq::Web => "/sidekiq" # UI do Sidekiq
  end
  end
end
