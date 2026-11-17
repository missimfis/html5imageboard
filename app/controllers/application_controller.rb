class ApplicationController < ActionController::Base
  BOARDS_PER_PAGE = 10
  POSTS_PER_PAGE = 6

  include Pagy::Method

  allow_browser versions: :modern

  protect_from_forgery with: :exception
end
