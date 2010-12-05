class PostsController < ApplicationController
  def create
    params[:post][:svg] = params["drawbox-data"]
    @board = Board.find(params[:board_id])
    @post = @board.posts.create(params[:post])
    redirect_to board_path(@board)
  end
  def image
    convert_png(params[:id]) unless Rails.cache.read("img-"+params[:id])

    send_data Rails.cache.read("img-"+params[:id]), :type => :png
  end
  private
    def convert_png(id)
      require 'RMagick'
      img = Magick::Image.from_blob(Post.find(id).svg)
      img[0].format = "png"
      Rails.cache.write("img-"+id,img[0].to_blob)
    end
end
