Rails.application.routes.draw do
  scope '/api' do
    mount Rswag::Ui::Engine => '/docs'
    mount Rswag::Api::Engine => '/docs'
    resources :users, only: [:index]
    
    post "/users", to: "users#create"
    get "/me", to: "users#me"
    post "/auth/login", to: "auth#login"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
