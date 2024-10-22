EvergreenMenus::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'user_registrations' }
  as :user do
    get 'register/:invitation', to: 'user_registrations#new', as: :new_invited_registration
  end

  resources :subscriptions, only: :create
  resources :plans, only: :index

  root to: 'home#index'

  get 'oauth/google/authorize' => 'oauth_google#authorize'
  get 'oauth/google/callback' => 'oauth_google#callback'
  delete 'oauth/google/revoke' => 'oauth_google#revoke'

  get 'oauth/facebook/authorize' => 'oauth_facebook#authorize'
  get 'oauth/facebook/callback' => 'oauth_facebook#callback'
  delete 'oauth/facebook/revoke' => 'oauth_facebook#revoke'

  post '/facebook/tab' => 'facebook_menus#show'
  get '/facebook/overcoming_custom_tab_restrictions' => 'help#facebook_custom_tab_restrictions'

  get '/terms' => 'terms#index'
  get '/privacy' => 'terms#privacy_policy'

  post '/contact' => 'contacts#create'

  # Stripe webhooks
  post '/stripe/events' => 'stripe#events'

  get 'amp/lists/:id' => 'amp_lists#show'
  resources :web_menus, only: :show
  resources :accounts do
    post '/cancel' => 'accounts#cancel', as: :cancellation
    resources :establishments do
      resources :lists
      resources :menus, path: '/print_menus'
      resources :digital_display_menus, path: '/digital_displays'
      resources :web_menus
      resources :online_menus, only: [:edit, :update]
      get 'web_menu_preview' => 'web_menus#preview'
      get 'online_menu_preview' => 'online_menus#preview'
      get 'digital_display_menu_preview' => 'digital_display_menus#preview'
      get 'menu_preview' => 'menus#preview'
    end

    resources :users, path: '/staff'
    resources :user_invitations

    namespace 'google_my_business' do
      resources :account_associations, only: [:new, :create]
      resources :establishment_associations, only: [:new, :create]
    end

    namespace 'facebook' do
      resources :establishment_associations, only: [:new, :create]
      post 'menu_tabs' => 'establishment_associations#tab'
    end
  end

  post '/sandbox/signup' => 'sandbox_signups#create', as: 'sandbox_signups'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
