require 'sidekiq/web'

Rails.application.routes.draw do
  root 'beers#index'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        # confirmations:      'devise_token_auth/confirmations',
        # passwords:          'devise_token_auth/passwords',
        # omniauth_callbacks: 'devise_token_auth/omniauth_callbacks',
        # sessions:           'devise_token_auth/sessions',
        # token_validations:  'devise_token_auth/token_validations',
        registrations:      'api/v1/devise/registrations'
      }
      resources :app_users
      resources :brands
    end
  end

  get '*path', to: 'app_users#index', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
