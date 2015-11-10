Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "pages#show", page: "start"

    resources :users

    get "/:page", to: "pages#show"
  end
end
