Rails.application.routes.draw do
  resource :incoming_message, only: [:create]

  # REMINDER shallow nests index, new, create actions
  # This scope will cause complaints for `bundle exec` commands if you've not yet
  # loaded the schema for the relevant environment.
  scope "(:skin)", constraints: { format: 'html' } do
    namespace :admin do
      root "claims#index"

      resources :claims, only: [:index, :show, :edit, :update, :create] do
        resources :letters, shallow: true
        resources :messages, only: [:index, :new, :create]
        resources :documents, only: [:new, :create]
        resources :notes, only: [:index]
      end
      resources :profiles, only: [:edit, :update] do
        resource :address, only: [:new, :create]
      end
      resources :addresses, only: [:edit, :update, :destroy]
      resources :documents, only: [:show, :edit, :update, :destroy]

      resources :companies, :awards, :claim_stages
      resources :supergroups, path: "organisations"
      resources :groups, path: "campaigns"

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
    
    resource   :feedback, only: [:new, :create], controller: 'feedback'

    # JSON lookup routes
    resources  :companies, only: [:index], constraints: { format: 'json' }
    resources  :addresses, only: [:edit, :update], constraints: { format: 'json' }

    # Membership API
    get "/membership", to: "memberships#show", as: :memberships
    # Help and custom pages
    get "/pages/:page", to: "pages#show", as: :pages

  end
end
