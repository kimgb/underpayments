Rails.application.routes.draw do
  get "/test_exception", to: "pages#test_exception_notification"

  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "claims#new"

    devise_for :users

    concern :addressable do
      resources :addresses, only: [:new, :create]
    end

    resources :users, concerns: :addressable

    resources :claims, concerns: :addressable do
      resources :employers, only: [:new, :create]
      resources :workplaces, only: [:new, :create]
      resources :documents, only: [:index, :new, :create]
    end

    resources :employers, concerns: :addressable, except: [:index, :new, :create]
    resources :workplaces, concerns: :addressable, except: [:index, :new, :create]

    resources :documents, except: [:index, :new, :create]
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
