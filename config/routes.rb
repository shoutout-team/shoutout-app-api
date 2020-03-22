Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :static do
      get 'companies', to: :companies
    end

    namespace :v1 do
      get 'load', to: 'entities#load'
      get 'companies', to: 'entities#companies'
      get 'categories', to: 'entities#categories'
      get 'keepers', to: 'entities#keepers'
      get 'locations', to: 'entities#locations'
      post 'members/login', to: 'members#login'
      post 'members/signup', to: 'members#signup'
      post 'companies/add', to: 'companies#create'
      post 'companies/(:keeper_token)/edit', to: 'companies#update'
    end
  end

  get 'welcome', to: 'pages#index'

  root to: 'pages#index'
end
