require 'sidekiq/web'

Rails.application.routes.draw do
  root 'beers#index'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :beers
      resources :brands
    end
  end

  get '*path', to: 'beers#index', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
