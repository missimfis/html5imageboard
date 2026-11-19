Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :boards, only: %i[index show create edit update destroy] do
    resources :posts, only: %i[show create edit update destroy]
  end

  get "posts/image/:id", to: "posts#image", as: :post_image

  resource :moderation, only: %i[new create destroy], controller: "moderation"

  get "/sitemap.xml", to: "sitemaps#index", as: :sitemap, defaults: { format: "xml" }
  get "/robots.txt", to: "robots#show", as: :robots, defaults: { format: "txt" }

  root "boards#index"
end
