Rails.application.routes.draw do
  get 'welcome', to: 'pages#index'

  root to: 'pages#index'
end
