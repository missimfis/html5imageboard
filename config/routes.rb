Rails.application.routes.draw do
  resources :boards, only: %i[index show create edit update destroy] do
    resources :posts
  end

  get "posts/image/:id", to: "posts#image", as: :post_image

  root "boards#index"
end
