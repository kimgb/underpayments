Rails.application.routes.draw do
  scope "(:locale)", locale: /en|en-AU|zh|zh-TW|vi/ do
    root "users#new"

    resources :users
  end
end
