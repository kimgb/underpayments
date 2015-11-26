Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "pages#show", page: "start"

    devise_for :users

    resources :users, shallow: true do
      resources :addresses, only: [:new, :create]
      resources :claims, only: [:new, :create]
    end

    resources :claims, shallow: true, except: [:new, :create] do
      resources :addresses, only: [:new, :create]
      resources :employers, only: [:new, :create]
      resources :documents, only: [:index, :new, :create]
    end

    resources :employers, shallow: true, except: [:new, :create] do
      resources :addresses, only: [:new, :create]
    end

    resources :addresses, except: [:index, :new, :create]
    resources :documents, except: [:index, :new, :create]

    get "/:page", to: "pages#show"
  end
end
