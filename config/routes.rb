Rails.application.routes.draw do
  root "products#index"

  resources :products

  resources :orders, only: [:create]

  resource :cart, only: [:show, :destroy] do
    post :add, path: "add/:id"
    # collection do
    #   get :checkout2
    # end
    get :checkout
  end
end
