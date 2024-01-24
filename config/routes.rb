Rails.application.routes.draw do
  mount SolidusStripe::Engine, at: '/solidus_stripe'
  root to: 'home#index'
  get 'about_us', to: 'home#about_us'
  get 'services', to: 'home#services'
  get 'services_term', to: 'home#term_of_services', as: :term_of_services
  get 'services_and_term', to: 'home#term_and_services', as: :term_and_services
  get 'privacy_policy', to: 'home#privacy_policy'
  get 'flash_sale', to: 'home#flash_sale'
  get 'session_expiry_extend', to: 'home#session_expiry_extend'

  resources :invitation_cards do
    member do
      get 'add_text'
      post 'save_image'
      post 'save_template' # Add this line for saving the template
    end
  end

  resources :invitation_categories
  resources :subscriptions, only: [:new, :create, :index]

  get '/seller_information', to: 'users#seller_information', as: :seller_information

  get '/favourite_products', to: 'products#favourite_products', as: :favourite_products

  devise_for(:user, {
    class_name: 'Spree::User',
    singular: :spree_user,
    controllers: {
      sessions: 'user_sessions',
      registrations: 'user_registrations',
      passwords: 'user_passwords',
      confirmations: 'user_confirmations',
      omniauth_callbacks: 'user/omniauth_callbacks'
    },
    skip: [:unlocks],
    path_names: { sign_out: 'logout' }
  })

  resources :users

  resources :blog_posts do
    collection do
      get 'blog_list'
      get 'manage_reviews'
    end
  end
  
  resources :blog_reviews

  resources :blog_replies

  resources :sliders
  
  devise_scope :spree_user do
    get '/login', to: 'user_sessions#new', as: :login
    post '/login', to: 'user_sessions#create', as: :create_new_session
    match '/logout', to: 'user_sessions#destroy', as: :logout, via: Devise.sign_out_via
    get '/signup', to: 'user_registrations#new', as: :signup
    post '/signup', to: 'user_registrations#create', as: :registration
    get '/otp', to: 'user_registrations#otp', as: :otp
    post '/otp_verification', to: 'user_registrations#otp_verification', as: :otp_verification
    get '/resend_otp', to: 'user_registrations#resend_otp', as: :resend_otp
    get '/password/recover', to: 'user_passwords#new', as: :recover_password
    post '/password/recover', to: 'user_passwords#create', as: :reset_password
    get '/password/change', to: 'user_passwords#edit', as: :edit_password
    put '/password/change', to: 'user_passwords#update', as: :update_password
    get '/confirm', to: 'user_confirmations#show', as: :confirmation if Spree::Auth::Config[:confirmable]
  end

  resource :account, controller: 'users'

  resources :products do
    member do
      get 'add_to_favorites'
      get 'remove_from_favorites'
    end
  end

  resources :autocomplete_results, only: :index

  resources :cart_line_items, only: :create

  get '/locale/set', to: 'locale#set'
  post '/locale/set', to: 'locale#set', as: :select_locale

  resource :checkout_session, only: :new
  resource :checkout_guest_session, only: :create

  # non-restful checkout stuff
  patch '/checkout/update/:state', to: 'checkouts#update', as: :update_checkout
  get '/checkout/:state', to: 'checkouts#edit', as: :checkout_state
  get '/checkout', to: 'checkouts#edit', as: :checkout

  get '/orders/:id/token/:token' => 'orders#show', as: :token_order

  resources :orders, only: :show do
    resources :coupon_codes, only: :create
  end

  resource :cart, only: [:show, :update] do
    put 'empty'
  end

  # route globbing for pretty nested taxon and product paths
  get '/t/*id', to: 'taxons#show', as: :nested_taxons

  get '/unauthorized', to: 'home#unauthorized', as: :unauthorized
  get '/cart_link', to: 'store#cart_link', as: :cart_link

  # This line mounts Solidus's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Solidus relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :business_listing do
    get 'step1', to: 'steps#step1'
    post 'process_step1', to: 'steps#process_step1'
  
    get 'step2', to: 'steps#step2'
    post 'process_step2', to: 'steps#process_step2'
  
    get 'step3', to: 'steps#step3'
    post 'process_step3', to: 'steps#process_step3'
  
    get 'step4', to: 'steps#step4'
    post 'process_step4', to: 'steps#process_step4'
  
    get 'step5', to: 'steps#step5'
    post 'process_step5', to: 'steps#process_step5'
  
    get 'step6', to: 'steps#step6'
    post 'save_business_listing', to: 'steps#save_business_listing'
  
    get 'login_page', to: 'steps#login_page'
    post 'process_login_page', to: 'steps#process_login_page'
  
    get 'signup_page', to: 'steps#signup_page'
    post 'process_signup_page', to: 'steps#process_signup_page'
  
    get 'confirmation', to: 'steps#confirmation'
  end

end
