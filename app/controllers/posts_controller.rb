class PostsController < ApplicationController
   def create
      @board = Board.find(params[:board_id])
      @post = @board.posts.create(params[:post])
      redirect_to board_path(@board)
   end
end
