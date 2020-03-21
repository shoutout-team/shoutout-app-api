Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    get 'static/companies', to: 'static#companies'
  end

  get 'welcome', to: 'pages#index'

  root to: 'pages#index'
end
