Rails.application.routes.draw do
  resources :backgrounds

  mount Ckeditor::Engine => '/ckeditor'
  resources :activities do
    resources :posts
  end

  resources :posts 

  get '/category/:id', to: "postcategories#show"

  get '/grenland', to: "posts#index", place: 'grenland'
  get '/nikolaj', to: "posts#index", place: 'nikolaj'
  get '/forumbox', to: "posts#index", place: 'forumbox'
  # hardcode exhibitions location
  scope shallow_prefix: "grenland" do
    resources :pages
    resources :posts
    resources :photos
    resources :artists
  end
  
  # get '/grenland/*', place: "grenland"
  # get '/nikolai/*', place: "nikolai"
  # get '/forumbox/*', place: 'forumbox'
  
  resources :pages
  resources :groups
  resources :participants
  resources :activities
  
  namespace :admin do
    resources :activities
    resources :activitytypes do
      collection do
        post :sort
      end
    end
    resources :artists
    resources :backgrounds
    resources :events
    resources :partners
    resources :postcategories
    resources :posts
    resources :subsites
    resources :symposia do
      resources :groups do
        resources :participants
      end
    end
    
    resources :calls do
      resources :submissions do
        resources :comments
        resources :votes
      end
    end
    resources :pages
    resources :users
    resources :works
  end
  
  resources :events
  
  resources :partners
  resources :home
  resources :calls do
    member do
      get :apply
    end
    collection do
      get :thanks
    end
  end
  resources :user
  resources :submissions
  
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'
  get '/admin',  to: 'admin/posts#index'
end
