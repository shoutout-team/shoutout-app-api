Rails.application.routes.draw do
  namespace :api do
    get 'static/companies', to: 'static#companies'
  end

  get 'welcome', to: 'pages#index'

  root to: 'pages#index'
end
