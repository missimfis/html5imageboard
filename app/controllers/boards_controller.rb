class BoardsController < ApplicationController
  before_action :set_board, only: %i[show edit update destroy]

  rate_limit to: 10, within: 1.minute, only: :create

  def index
    @board = Board.new
    load_boards
  end

  def show
    @pagy, @posts = pagy(:offset, @board.posts.newest, limit: 4)
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
    redirect_to boards_url, notice: t("boards.destroyed")
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.expect(board: [:title])
  end

  def load_boards
    @pagy, @boards = pagy(:offset, Board.newest, limit: 10)
  end
end
