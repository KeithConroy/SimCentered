Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    authenticated :user do
      # root :to => 'organizations#show', as: :authenticated_root, via: :get
      get 'organizations/show'
    end
    unauthenticated :user do
      root :to => 'welcome#index', as: :unauthenticated_root
    end
  end
  # root 'welcome#index'

  get 'organizations/:organization_id/courses/search/:phrase' => 'courses#search'
  get 'organizations/:organization_id/events/search/:phrase' => 'events#search'
  get 'organizations/:organization_id/events/:event_id/modify_search/:phrase' => 'events#modify_search'
  get 'organizations/:organization_id/courses/:course_id/modify_search/:phrase' => 'courses#modify_search'
  get 'organizations/:organization_id/items/search/:phrase' => 'items#search'
  get 'organizations/:organization_id/rooms/search/:phrase' => 'rooms#search'
  get 'organizations/:organization_id/users/search/:phrase' => 'users#search'

  resources :organizations do

    resources :courses do
      post 'add_student/:id' => 'courses#add_student'
      delete 'remove_student/:id' => 'courses#remove_student'
    end

    resources :events do
      post 'add_course/:id' => 'events#add_course'
      # delete 'remove_course/:id' => 'events#remove_course'

      post 'add_student/:id' => 'events#add_student'
      delete 'remove_student/:id' => 'events#remove_student'

      post 'add_room/:id' => 'events#add_room'
      delete 'remove_room/:id' => 'events#remove_room'

      post 'add_item/:id' => 'events#add_item'
      delete 'remove_item/:id' => 'events#remove_item'

      get 'modify' => 'events#modify'
    end

    resources :items
    resources :rooms
    resources :users

  end

  get '/about' => 'welcome#about'
  get '/contact' => 'welcome#contact'
  get '/pricing' => 'welcome#pricing'
  get '/faq' => 'welcome#faq'

  get '/organizations/:id/community' => 'welcome#community'



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
