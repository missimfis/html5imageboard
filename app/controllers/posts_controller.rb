class PostsController < ApplicationController
  def create
    params[:post][:svg] = params["drawbox-data"]
    @board = Board.find(params[:board_id])
    @post = @board.posts.create(post_params)
    if @post.invalid?
      redirect_to board_path(@board), notice: "can't add post!"
    else
      redirect_to board_path(@board)
    end
  end

  def image
    cache_key = "img-" + params[:id]
    img_data = Rails.cache.read(cache_key)
    unless img_data
      img_data = convert_png(params[:id])
      Rails.cache.write(cache_key, img_data)
    end
    send_data img_data, type: :png, disposition: 'inline'
  end

  private

  def post_params
    params.require(:post).permit(:title, :svg, :description)
  end

  def convert_png(id)
    require 'mini_magick'
    svg_data = Post.find(id).svg
    image = MiniMagick::Image.read(svg_data)
    image.format("png")
    image.to_blob
  end
end
