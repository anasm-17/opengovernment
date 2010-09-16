OpenGov::Application.routes.draw do
  match '/us_map(.:format)' => 'home#us_map', :as => 'us_map', :defaults => {:format => "html"}

  constraints(Subdomain) do
    match '/' => 'states#show'
    match '/search' => 'states#search', :as => 'state_search'
    match '/subscriptions' => 'states#subscribe', :as => 'state_subscriptions'

    resources :people, :only => [:show, :index] do
      collection do
        get :upper
        get :lower
      end
      member do
        get :news
        get :sponsored_bills
        get :votes
        get :money_trail
      end
    end

    resources :sigs, :only => [:index, :show]
    resources :issues, :only => [:index, :show]
    resource :money_trail, :only => [:show]

    match '/bills', :to => 'bills#index', :as => 'bills'
    match '/bills/upper', :to => 'bills#upper', :as => 'bills_upper'
    match '/bills/lower', :to => 'bills#lower', :as => 'bills_lower'

    resources :bills, :only => [:show], :path => '/sessions/:session/bills' do
      member do
        get :major_actions
        get :news
        get :money_trail
      end
      shallow do
        resources :actions, :only => [:show]
        resources :votes, :only => [:show]
      end
    end

    resources :committees, :only => [:show] do
      collection do
        get :upper
        get :lower
        get :joint
      end
    end
  end

  namespace :admin do
    root :to => "home#index"
    resources :states
    resources :people, :only => [:edit, :update]
    resources :issues, :only => [:create, :index, :destroy, :update] do
      collection do
        get :bills
        get :categories
      end
    end
    resources :taggings, :only => [:create, :destroy]
  end

  match '/search' => 'districts#search', :as => 'search'

  # Track traffic on a given page
  match '/tracking.gif' => TrackingApp

  root :to => "home#index"

  resources :pages, :only => :show
end
