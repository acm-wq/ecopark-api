Rails.application.routes.draw do
  scope '/api' do
    mount Rswag::Ui::Engine => '/docs'
    mount Rswag::Api::Engine => '/docs'
    resources :users, only: [ :index, :create ]

    get "/me", to: "users#me"
    post "/auth/login", to: "auth#login"

    resources :categories, only: [ :index, :create, :update, :destroy ]
    resources :landmarks, only: [ :index, :create ]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
