Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :static do
      get 'companies', to: :companies
    end

    namespace :v1 do
      get 'companies', to: :companies
      get 'categories', to: :categories
      get 'keepers', to: :keepers
    end
  end

  get 'welcome', to: 'pages#index'

  root to: 'pages#index'
end
