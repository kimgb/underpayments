Rails.application.routes.draw do
  resources :groups
  scope "(:group)", group: Regexp.new(Group.all.map(&:slug).join("|")) do
    root "claims#new"

    # TODO will devise tolerate singular user? 
    # No need for multiple user visibility except in the admin space
    devise_for :users, controllers: { invitations: 'users/invitations' }
    resources  :users
    
    resource   :profile
    # TODO nest singular address - split forms?
    
    # TODO singular resource for basic namespace claim
    resources  :claims do
      resources :documents, only: [:index, :new, :create]
      resources :claim_companies, only: [:new, :create]
    end
    
    resources  :documents, except: [:index, :new, :create]
    
    resources  :companies, only: [:show] do
      resources :claim_companies, only: [:new, :create]
      # TODO singular resource for company_address?
      resources :company_addresses, only: [:new, :create]
    end
    
    resources  :claim_companies, except: [:index, :new, :create]
    resources  :company_addresses, except: [:index, :new, :create]
    
    # JSON lookup routes
    resources  :companies, only: [:index]
    resources  :addresses, only: [:edit, :update]
    
    get "/membership", to: "memberships#show", as: :memberships

    get "/pages/:page", to: "pages#show", as: :pages
  end

  namespace :admin do
    root "users#index"

    resources :users, only: [:show, :index] do
      resources :messages, only: [:new, :create]
      resources :letters, only: [:new, :create, :show]
    end
    resources :claims, only: [:update]
    resources :companies, except: [:new, :create]
    
    resources :supergroups
    resources :groups
  end
end
