class PostsController < ApplicationController
  def create
    params[:post][:svg] = params["drawbox-data"]
    @board = Board.find(params[:board_id])
    @post = @board.posts.create(params[:post])
    if @post.invalid?
      redirect_to board_path(@board), :notice => "can't add post!"
    else
      redirect_to board_path(@board)
    end
  end
  def image
    cache_key = "img-"+params[:id]
    img_data = Rails.cache.read(cache_key)
    unless img_data
      img_data = convert_png(params[:id])
      Rails.cache.write(cache_key, img_data)
    end
    send_data img_data,:type => :png,:disposition => 'inline'
  end
  private
    def convert_png(id)
      require 'RMagick'
      img = Magick::Image.from_blob(Post.find(id).svg)
      img[0].format = "png"
      return img[0].to_blob
    end
end
