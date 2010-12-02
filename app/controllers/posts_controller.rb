class PostsController < ApplicationController
   def create
     params[:post][:svg] = params["drawbox-data"]
     @board = Board.find(params[:board_id])
     @post = @board.posts.create(params[:post])
     redirect_to board_path(@board)
   end
end
