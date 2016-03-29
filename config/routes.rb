Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    authenticated :user do
      root :to => 'organizations#show', as: :authenticated_root, via: :get
    end
    unauthenticated :user do
      root :to => 'home#index', as: :unauthenticated_root
    end
  end

  resources :organizations do
    resources :courses do
      member do
        post 'add_student'
        delete 'remove_student'

        get 'modify_search'
      end
      get 'search', on: :collection
    end

    resources :events do
      member do
        post 'add_course'
        delete 'remove_course'

        post 'add_student'
        delete 'remove_student'

        post 'add_room'
        delete 'remove_room'

        post 'add_item'
        delete 'remove_item'

        get 'modify_search'
      end
      get 'search', on: :collection
    end

    resources :items do
      get 'search', on: :collection
      get 'heatmap', on: :member
    end
    resources :rooms do
      get 'search', on: :collection
      get 'heatmap', on: :member
    end
    resources :users do
      get 'search', on: :collection
    end

    get 'community', on: :member
  end

end
