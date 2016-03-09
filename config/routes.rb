Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "claims#new"

    devise_for :users
    resources  :users
    
    resource   :profile
    
    resources  :claims do
      resources :documents, only: [:index, :new, :create]
      resources :claim_companies, only: [:new, :create]
    end
    
    resources  :documents, except: [:index, :new, :create]
    
    resources  :companies, only: [:show] do
      resources :claim_companies, only: [:new, :create]
      resources :company_addresses, only: [:new, :create]
    end
    
    resources  :claim_companies, except: [:index, :new, :create]
    resources  :company_addresses, except: [:index, :new, :create]
    
    # JSON lookup resources
    resources  :companies, only: [:index]
    resources  :addresses, only: [:edit, :update]

    get "/pages/:page", to: "pages#show", as: :pages

    namespace :admin do
      root "users#index"

      resources :users, only: [:show, :index] do
        resources :messages, only: [:new, :create]
      end
      resources :claims, only: [:update]
    end
  end
end
