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
    get 'dashboard', to: 'backend#index', as: :dashboard

    get 'companies', to: 'companies#index', as: :list_companies
    get 'companies/approve/:id', to: 'companies#approve', as: :approve_company
    get 'companies/reject/:id', to: 'companies#reject', as: :reject_company
    get 'companies/add', to: 'companies#add', as: :add_company
    get 'companies/edit/:id', to: 'companies#edit', as: :edit_company
    post 'companies/create', to: 'companies#create', as: :create_company
    patch 'companies/update/:id', to: 'companies#update', as: :update_company

    get 'users', to: 'users#index', as: :list_users
    get 'users/approve/:id', to: 'users#approve', as: :approve_user
    get 'users/reject/:id', to: 'users#reject', as: :reject_user
    get 'users/add', to: 'users#add', as: :add_user
    get 'users/edit/:id', to: 'users#edit', as: :edit_user
    post 'users/create', to: 'users#create', as: :create_user
    patch 'users/update/:id', to: 'users#update', as: :update_user

    get 'uploads', to: 'uploads#index', as: :list_uploads
    get 'uploads/:id', to: 'uploads#show', as: :show_upload
    delete 'uploads/:id', to: 'uploads#remove', as: :remove_upload
    get 'upload/new', to: 'uploads#new', as: :new_upload
    post 'upload', to: 'uploads#upload', as: :upload_asset
    patch 'update', to: 'uploads#update', as: :update_asset
  end

  root to: 'backend#index'
end
