require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        # confirmations:      'devise_token_auth/confirmations',
        # passwords:          'devise_token_auth/passwords',
        # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
        # sessions:           'devise_token_auth/sessions',
        # token_validations:  'devise_token_auth/token_validations',
      # registrations:      'api/v1/devise/registrations'
      }
      resources :app_users,  only: %i[show index]
      resources :brands
      resources :countries
      resources :cities
      resources :roles
      resources :users_roles
      resources :product_sub_categories
      resources :product_category_heads
      resources :category_brands
      resources :products
      resources :languages
      resources :brands
      resources :models
      resources :product_categories
      resources :budgets

      get 'all_cities', to: 'cities#all_cities'
      get 'get_image_url', to: 'products#get_image_url'
      get 'get_products', to: 'products#get_products'
      get 'categories_list', to: 'product_categories#categories_list'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
