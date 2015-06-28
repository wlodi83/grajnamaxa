Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  get 'tags/:tag', to: 'games#index', as: :tag
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users, only: [:index, :destroy] do
     get 'admin', on: :collection
     get 'points', on: :member
  end
  root 'welcome#index'
  get 'warunki_korzystania_z_witryny', to: 'welcome#terms_of_use', as: :terms_of_use
  get 'polityka_prywatnosci', to: 'welcome#privacy_policy', as: :privacy_policy
  get 'o_nas', to: 'welcome#about', as: :about
  get 'informacja_dla_rodzicow', to: 'welcome#for_parents', as: :for_parents
  resources :contacts, only: [:new, :create]
  resources :games do
    collection do
      get 'admin'
      get 'search'
    end
    member do
      get 'publish'
      get 'unpublish'
    end
    resources :comments, only: [:new, :create]
    get '/comments/new/(:parent_id)', to: 'comments#new', as: :new_comment
  end
  resources :comments, only: [:index, :destroy]
  resources :categories, concerns: :paginatable

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
