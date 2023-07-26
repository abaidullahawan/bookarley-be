require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        confirmations:      'api/v1/devise/confirmations',
        # passwords:          'devise_token_auth/passwords',
        # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
        sessions:           'api/v1/devise/sessions',
        # token_validations:  'devise_token_auth/token_validations',
        # registrations:      'api/v1/devise/registrations'
      }
      resources :app_users,  only: %i[show index update]
      resources :countries
      resources :cities
      resources :roles
      resources :users_roles
      resources :product_sub_categories
      
      resources :product_category_heads
      resources :products
      resources :languages
      resources :brands
      resources :models
      resources :product_categories do
        member do
          get :find_product_sub_categories
        end
      end
      resources :budgets
      resources :product_mappings
      resources :website_names,  only: %i[index]
      resources :stores
      resources :priority_sliders

      post 'add_store_products/:id', to: 'stores#add_store_products'
      post 'remove_store_products/:id', to: 'stores#remove_store_products'
      get 'get_products_without_store', to: 'stores#products_without_store'


      get 'all_cities', to: 'cities#all_cities'
      get 'get_products', to: 'products#get_products'
      get 'get_products_for_landing_page', to: 'products#get_products_for_landing_page'
      get 'get_mappings', to: 'product_mappings#get_mappings'
      post 'favourite_ads', to: 'products#favourite_ads'
      get 'brand_with_products/:id', to: 'brands#brand_with_products'
      get 'categories_list', to: 'product_categories#categories_list'
      get 'favourite_products', to: 'products#favourite_products'
      post 'reported_ads', to: 'products#reported_ads'
      get 'search_products_by_title', to: 'products#search_products_by_title'
      post 'import_data_form_csv', to: 'products#import_data_form_csv'
      get 'get_verification_requested_users', to: 'app_users#get_verification_requested_users'
      get 'get_verified_users', to: 'app_users#get_verified_users'
      get 'get_system_notifications', to: 'products#getSystemNotifications'

			
    end
  end
  # resources :categories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
