class BoardsController < ApplicationController
  before_action :set_board, only: %i[show edit update destroy]

  rate_limit to: 10, within: 1.minute, only: %i[create update destroy]

  def index
    @board = Board.new
    load_boards
  end

  def show
    @post = @board.posts.build
    load_posts
  end

  def edit; end

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to @board, notice: t("boards.created")
    else
      load_boards
      render :index, status: :unprocessable_content
    end
  end

  def update
    if @board.update(board_params)
      redirect_to @board, notice: t("boards.updated")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_url, notice: t("boards.destroyed"), status: :see_other
  end

  private

  def set_board
    @board = Board.find(params.expect(:id))
  end

  def board_params
    params.expect(board: %i[title])
  end

  def load_boards
    @pagy, @boards = pagy(:offset, Board.newest, limit: BOARDS_PER_PAGE)
  end

  def load_posts
    @pagy, @posts = pagy(:offset, @board.posts.newest, limit: POSTS_PER_PAGE)
  end
end
