Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :boards, only: %i[index show create edit update destroy] do
    resources :posts, only: %i[show create edit update destroy]
  end

  get "posts/image/:id", to: "posts#image", as: :post_image

  root "boards#index"
end
