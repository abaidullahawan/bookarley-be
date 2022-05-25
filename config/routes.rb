Rails.application.routes.draw do
  root 'beers#index'

  namespace :api do
    namespace :v1 do
      resources :beers
      resources :brands
    end
  end

  get '*path', to: 'beers#index', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
