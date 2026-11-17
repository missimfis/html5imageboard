class SitemapsController < ApplicationController
  def index
    expires_in 1.hour, public: true

    @boards = Board.order(:id).select(:id, :title, :updated_at)
    @posts = Post.order(:id).select(:id, :board_id, :title, :updated_at).includes(:board)
  end
end
