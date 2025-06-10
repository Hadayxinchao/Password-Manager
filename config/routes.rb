Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  root "password_entries#index"
  resources :password_entries, except: [ :new, :edit ] do
    collection do
      get :search
      get :favorites
    end

    member do
      post :favorite
      post :unfavorite
    end
  end
end
