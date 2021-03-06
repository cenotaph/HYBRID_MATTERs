Rails.application.routes.draw do

  get 'errors/not_found'

  get 'errors/internal_server_error'

  resources :projects do
    get :events, to: 'activities#index'
    resources :posts
    resources :activities
    resources :pages
    resources :calls
  end
  resources :backgrounds

  mount Ckeditor::Engine => '/ckeditor'
  resources :activities do
    resources :posts
  end
  themes_for_rails
  resources :posts

  get '/category/:id', to: "postcategories#show"
  resources :calendar
  # get '/grenland', to: "posts#index", place: 'grenland'
  resources :works
  resources :artists
  # get '/nikolaj', to: "posts#index", place: 'nikolaj'
  # get '/forumbox', to: "posts#index", place: 'forumbox'

  # hardcode exhibitions location
  scope path: '/grenland' do
    root 'pages#curatorial_statement', :as => :grenland_root, place: 'grenland'
    resources :posts, place: 'grenland'
    resources :works, place: 'grenland'
    resources :artists, place: 'grenland'
  end

  scope path: '/nikolaj' do
    root 'pages#curatorial_statement', id: 'grenland-statement', :as => :nikolai_root, place: 'nikolaj'
    resources :posts, place: 'nikolaj'
    resources :works, place: 'nikolaj'
    resources :artists, place: 'nikolaj'
  end

  scope path: '/forumbox' do
    root 'pages#curatorial_statement', id: 'grenland-statement', :as => :forumbox_root, place: 'forumbox'
    resources :posts, place: 'forumbox'
    resources :works, place: 'forumbox'
    resources :artists, place: 'forumbox'
  end

  # get '/grenland/*', place: "grenland"
  # get '/nikolai/*', place: "nikolai"
  # get '/forumbox/*', place: 'forumbox'

  resources :pages
  resources :groups
  resources :participants
  resources :supporters
  get '/speakers', to: "participants#index"
  resources :symposium_registrations
  resources :activities

  namespace :admin do
    resources :activities
    resources :activitytypes do
      collection do
        post :sort
      end
    end
    resources :artists do
      resources :stays
    end
    resources :frontitems
    resources :backgrounds
    resources :events
    resources :partners
    resources :postcategories
    resources :posts do
      collection do
        post :search
      end
    end
    resources :projects
    resources :pressreleases
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
  resources :pressreleases
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
  resources :search
  resources :projects
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get '/program', to: 'program#index'
  get '/residencies', to: 'artists#index'
  get '/residencies/:id', to: 'artists#show', as: :residency
  # You can have the root of your site routed with "root"
  get '/' => 'pages#show', id: 'statement', :constraints => { :subdomain => 'symposium' }
  root to: 'home#home'
  get '/admin',  to: 'admin/posts#index'
  get 'making_life', controller: :projects, action: :show, id: 'making-life'
  get '/feed' => 'feeds#index', :defaults => { :format => 'rss' }
  get '/about', to: 'home#about'
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
end
