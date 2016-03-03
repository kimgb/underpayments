Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "claims#new"

    devise_for :users
    resources :users
    resources :claims do
      resources :documents, only: [:index, :new, :create]
      resources :claim_companies, only: [:new, :create]
      resources :companies, only: [:new, :create]
    end
    resources :documents, except: [:index, :new, :create]
    resources :claim_companies, except: [:index, :new, :create]
    resources :companies, except: [:index] do
      resources :company_addresses, only: [:new, :create]
    end
    resources :addresses, except: [:index, :new, :create]
    resource  :profile

    get "/:page", to: "pages#show", as: :pages

    namespace :admin do
      root "users#index"

      resources :users, only: [:show, :index] do
        resources :messages, only: [:new, :create]
      end
      resources :claims, only: [:update]
    end
  end
end
