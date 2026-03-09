class BoardsController < ApplicationController
  def index
    @board = Board.new
    @boards = Board.order(created_at: :desc)
               .paginate(page: params[:page], per_page: 10)
  respond_to do |format|
      format.html
    end
  end

  def show
    @board = Board.find(params[:id])
@posts = @board.posts.order('created_at DESC').paginate(page: params[:page], per_page: 4)

    respond_to do |format|
      format.html
    end
  end

  def edit
    @board = Board.find(params[:id])
  end

  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to(@board, notice: 'Board was successfully created. Start adding a post...') }
      else
        @boards = Board.all
        format.html { render action: "index" }
      end
    end
  end

  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to(@board, notice: 'Image board was successfully updated.') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to(boards_url) }
    end
  end

  private

  def board_params
    params.require(:board).permit(:title)
  end
end
