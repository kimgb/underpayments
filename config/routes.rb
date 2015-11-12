Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "pages#show", page: "start"

    resources :users, shallow: true do
      resources :addresses
      resources :claims
    end

    resources :claims, shallow: true do
      resources :addresses
      resources :employers
    end

    resources :employers, shallow: true do
      resources :addresses
    end

    get "/:page", to: "pages#show"
  end
end
