Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "pages#show", page: "start"

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

    resource :address, except: [:index, :new, :create]
    resource :document, except: [:index, :new, :create]

    get "/:page", to: "pages#show"
  end
end
