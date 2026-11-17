require "test_helper"

class BoardTest < ActiveSupport::TestCase
  test "title is required" do
    board = Board.new
    assert_not board.valid?
    assert board.errors.added?(:title, :blank)
  end

  test "title must be unique" do
    board = Board.new(title: boards(:general).title)
    assert_not board.valid?
    assert_includes board.errors[:title], "has already been taken"
  end

  test "title uniqueness ignores case" do
    board = Board.new(title: boards(:general).title.downcase)
    assert_not board.valid?
    assert_includes board.errors[:title], "has already been taken"
  end

  test "title is normalized" do
    board = Board.create!(title: "  New   Board  ")
    assert_equal "New Board", board.title
  end

  test "title has a maximum length" do
    board = Board.new(title: "a" * (Board::TITLE_MAX_LENGTH + 1))
    assert_not board.valid?
    assert board.errors.added?(:title, :too_long, count: Board::TITLE_MAX_LENGTH)
  end

  test "destroying a board destroys its posts" do
    board = boards(:general)
    assert_difference -> { Post.count }, -board.posts.count do
      board.destroy
    end
  end

  test "newest scope orders by creation date descending" do
    assert_equal Board.order(created_at: :desc, id: :desc).to_a, Board.newest.to_a
  end
end
