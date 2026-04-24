class PostsController < ApplicationController
  def create
    params[:post][:svg] = params["drawbox-data"]
    @board = Board.find(params[:board_id])
    @post = @board.posts.create(post_params)
    if @post.invalid?
      redirect_to board_path(@board), alert: "can't add post!"
    else
      redirect_to board_path(@board), notice: "Post created!"
    end
  end

  def show
    @board = Board.find(params[:board_id])
    @post = @board.posts.find(params[:id])
  end

  def edit
    @board = Board.find(params[:board_id])
    @post = @board.posts.find(params[:id])
  end

  def update
    @board = Board.find(params[:board_id])
    @post = @board.posts.find(params[:id])

    if params["drawbox-data"].present?
      @post.svg = params["drawbox-data"]
    end

    if @post.update(post_params)
      redirect_to board_path(@board), notice: "Post updated!"
    else
      render :edit
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    @post = @board.posts.find(params[:id])
    @post.destroy
    redirect_to board_path(@board), notice: "Post deleted!"
  end

  def image
    cache_key = "img-" + params[:id]
    img_data = Rails.cache.read(cache_key)

    unless img_data
      post = Post.find(params[:id])
      img_data = decode_image(post.svg)
      Rails.cache.write(cache_key, img_data)
    end

    send_data img_data, type: "image/png", disposition: "inline"
  end

  private

  def post_params
    params.require(:post).permit(:title, :svg, :description)
  end

  def decode_image(svg_or_base64)
    return nil if svg_or_base64.blank?

    if svg_or_base64.start_with?("data:image/png;base64,")
      Base64.decode64(svg_or_base64.sub("data:image/png;base64,", ""))
    elsif svg_or_base64.start_with?("iVBORw0KGgo", "iVBOR")
      Base64.decode64(svg_or_base64)
    else
      require "mini_magick"
      image = MiniMagick::Image.read(svg_or_base64)
      image.format("png")
      image.to_blob
    end
  rescue => e
    Rails.logger.error "Image decode error: #{e.message}"
    nil
  end
end