Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "pages#show", page: "start"

    resources :users do
      resources :addresses
      resources :claims
    end

    get "/:page", to: "pages#show"
  end
end
