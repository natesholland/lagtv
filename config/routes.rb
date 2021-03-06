require 'resque/server'

Lagtv::Application.routes.draw do
  mount Resque::Server.new, :at => "/resque"
  mount Forem::Engine, :at => "/forums"
  root :to => 'pages#home'  

  get 'login', to: 'sessions#new', as: 'login'
  get 'register', to: 'users#new', as: 'register'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  match "/my_profile" => "users#edit", :as => :my_profile
  match "/about" => "pages#about", :as => :about
  match "/latest_posts" => "pages#latest_posts", :as => :latest_posts
  match "/mark_all_as_viewed" => "users#mark_all_as_viewed", :as => :mark_all_as_viewed
  match "/streams" => "pages#streams", :as => :streams
  match "/profiles/:profile_url" => "users#show", :as => :profile

  resources :sessions
  resources :password_reset
  resources :categories
  resources :users do
    member do
      get 'topics', :to => 'users#topics'
      get 'add_service', :to => 'users#add_service'
      
    end

    collection do
      post 'report_profile', :to => 'users#report_profile'
    end

    resources :replays do
      collection do
        get 'page', :to => 'replays#user_page'
      end
    end
  end

  resources :replays do
    resources :comments

    collection do
      get 'download'
      get 'bulk_update'
    end
  end

  resources :announcements do
    member do
      get 'hide'
    end
  end

  resources :emails, :only => [:new, :create, :show, :index]
  resources :profile_services
end
