Beermapper::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'user_registrations' }
  as :user do
    get 'register/:invitation', to: 'user_registrations#new', as: :new_invited_registration
  end

  root to: 'home#index'

  resources :web_menus, only: :show
  resources :accounts do
    resources :establishments do
      resources :lists
      resources :menus, path: '/print_menus'
      resources :digital_display_menus, path: '/digital_displays'
      resources :web_menus
      get 'web_menu_preview' => 'web_menus#preview'
      get 'digital_display_menu_preview' => 'digital_display_menus#preview'
      get 'menu_preview' => 'menus#preview'
    end

    resources :users, path: '/staff'
    resources :user_invitations
  end
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
