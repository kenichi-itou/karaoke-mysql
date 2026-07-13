Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :reservations
  resources :usage_reports, only: [:index] do
    collection { get :by_room }
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # 開発環境: 送信メール確認用UI
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Defines the root path route ("/")
  root "reservations#index"
end
