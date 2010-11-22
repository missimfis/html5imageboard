class PostsController < ApplicationController
   def create
      @post = Post.find(params[:post_id])
      @post.comment = [:comment])
      redirect_to post_path(@post)
   end
end
