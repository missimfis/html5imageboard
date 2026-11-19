class PostsController < ApplicationController
  before_action :set_board, except: :image
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post_owner!, only: %i[edit update destroy]

  rate_limit to: 10, within: 1.minute, only: %i[create update destroy]
  rate_limit to: 60, within: 1.minute, only: :image

  def show; end

  def edit; end

  def create
    @post = build_post

    if @post.save
      redirect_to board_path(@board), notice: t("posts.created")
    else
      load_posts
      render "boards/show", status: :unprocessable_content
    end
  end

  def update
    attributes = post_params
    attributes[:image_data] = image_data_param if image_data_param.present?

    if @post.update(attributes)
      redirect_to board_path(@board), notice: t("posts.updated")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy
    redirect_to board_path(@board), notice: t("posts.destroyed"), status: :see_other
  end

  def image
    post = Post.find(params.expect(:id))
    image_data = fetch_image_data(post)
    return head :not_found unless image_data

    expires_in 1.year, public: true, immutable: true
    send_data image_data,
              type: "image/png",
              disposition: "inline",
              filename: "post-#{post.id}.png"
  end

  private

  def fetch_image_data(post)
    Rails.cache.fetch(
      "post-image/#{post.cache_key_with_version}",
      expires_in: 1.hour
    ) { decode_image(post.image_data) }
  end

  def set_board
    @board = Board.find(params.expect(:board_id))
  end

  def set_post
    @post = @board.posts.find(params.expect(:id))
  end

  def authorize_post_owner!
    authorize_owner!(@post, fallback_location: board_path(@board))
  end

  def build_post
    @board.posts.new(
      post_params.merge(
        image_data: image_data_param,
        owner_token: current_owner_token
      )
    )
  end

  def post_params
    params.expect(post: %i[title description])
  end

  def image_data_param
    params[:drawbox_data].presence
  end

  def load_posts
    @pagy, @posts = pagy(:offset, @board.posts.newest, limit: POSTS_PER_PAGE)
  end

  def decode_image(image_data)
    PngImage.decode(image_data)
  end
end
