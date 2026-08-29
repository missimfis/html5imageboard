class PostsController < ApplicationController
  PNG_DATA_URI_PREFIX = "data:image/png;base64,".freeze
  MAX_DECODED_IMAGE_BYTES = 10.megabytes

  before_action :set_board, except: :image
  before_action :set_post, only: %i[show edit update destroy]

  rate_limit to: 10, within: 1.minute, only: %i[create destroy]
  rate_limit to: 60, within: 1.minute, only: :image

  def show; end

  def edit; end

  def create
    @post = @board.posts.new(post_params.merge(svg: params[:drawbox_data]))

    if @post.save
      redirect_to board_path(@board), notice: t("posts.created")
    else
      redirect_to board_path(@board), alert: t("posts.create_failed")
    end
  end

  def update
    attributes = post_params
    attributes[:svg] = params[:drawbox_data] if params[:drawbox_data].present?

    if @post.update(attributes)
      redirect_to board_path(@board), notice: t("posts.updated")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy
    redirect_to board_path(@board), notice: t("posts.destroyed")
  end

  def image
    post = Post.find(params[:id])
    image_data = fetch_image_data(post)
    return head :not_found unless image_data

    expires_in 1.year, public: true, immutable: true
    send_data image_data, type: "image/png", disposition: "inline"
  end

  private

  def fetch_image_data(post)
    Rails.cache.fetch("img-#{post.id}-#{post.updated_at.to_i}", expires_in: 1.hour) do
      decode_image(post.svg)
    end
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_post
    @post = @board.posts.find(params[:id])
  end

  def post_params
    params.expect(post: %i[title svg description])
  end

  def decode_image(svg_or_base64)
    return nil unless decodeable_png?(svg_or_base64)

    png_data = Base64.decode64(svg_or_base64.delete_prefix(PNG_DATA_URI_PREFIX))
    return nil if png_data.bytesize.zero? || png_data.bytesize > MAX_DECODED_IMAGE_BYTES

    png_data
  end

  def decodeable_png?(svg_or_base64)
    return false if svg_or_base64.blank?

    svg_or_base64.start_with?(PNG_DATA_URI_PREFIX) || svg_or_base64.start_with?("iVBOR")
  end
end
