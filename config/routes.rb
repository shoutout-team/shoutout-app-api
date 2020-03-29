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
      post 'locations/search', to: 'locations#search'
      post 'locations/cities', to: 'locations#cities'
      post 'members/login', to: 'members#login'
      post 'members/signup', to: 'members#signup'
      post 'members/(:keeper_token)/edit', to: 'members#update'
      get 'companies/fetch', to: 'companies#fetch'
      post 'companies/add', to: 'companies#create'
      post 'companies/approve', to: 'companies#approve' # TODO: This endpoint must be restricted to dev-clients #43
      post 'companies/(:keeper_token)/edit', to: 'companies#update'
      get 'assets/:key', to: 'assets#show'
      post 'assets/:entity/:kind', to: 'assets#upload'
    end
  end

  namespace :backend do
    get 'companies/approve/:id', to: 'companies#approve', as: :approve_company
    get 'companies/reject/:id', to: 'companies#reject', as: :reject_company
  end

  get 'welcome', to: 'pages#index'

  root to: 'pages#index'
end
