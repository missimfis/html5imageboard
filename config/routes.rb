Html5imageboard::Application.routes.draw do
  resources :boards, only: [:index, :show, :create, :edit, :update, :destroy] do
    resources :posts
  end

  get "posts/image/:id", to: "posts#image"

  root to: "boards#index"
end