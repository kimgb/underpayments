Rails.application.routes.draw do
  # REMINDER shallow nests index, new, create actions
  scope "(:skin)" do
    namespace :admin do
      root "users#index"

      resources :users, only: [:show, :index] do
        resources :messages, only: [:new, :create]
        resources :letters, only: [:new, :create, :show]
      end
      resources :claims, only: [:update]
      resources :companies, except: [:new, :create]

      resources :supergroups, :groups

      get "/preview", to: "previews#show"
    end

    root "claims#new"

    # TODO will devise tolerate singular user?
    # No need for multiple user visibility except in the admin space
    devise_for :users, controllers: { invitations: 'users/invitations' }
    resources  :users

    resource   :profile
    # TODO nest singular address - split forms?

    # TODO singular resource for basic namespace claim?
    resources  :claims do
      resources :documents, shallow: true
      resources :claim_companies, shallow: true
    end

    resources  :companies, only: [:show] do
      # TODO singular resource for company_address?
      resources :company_addresses, shallow: true
      resources :claim_companies, shallow: true
    end

    # JSON lookup routes
    resources  :companies, only: [:index]
    resources  :addresses, only: [:edit, :update]

    # Membership API
    get "/membership", to: "memberships#show", as: :memberships
    # Help and custom pages
    get "/pages/:page", to: "pages#show", as: :pages

  end

end
