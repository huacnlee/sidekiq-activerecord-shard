Rails.application.routes.draw do
  resources :posts
  post "/tenant", to: "welcome#set_tenant"
end
