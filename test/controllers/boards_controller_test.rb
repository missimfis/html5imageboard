require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "index lists boards" do
    get boards_url
    assert_response :success
    assert_select "h1", "Boards"
    assert_select ".board-title", boards(:general).title
  end

  test "show displays a board and its posts" do
    get board_url(boards(:general))
    assert_response :success
    assert_select "h1", boards(:general).title
    assert_select ".post-title", posts(:hello).title
  end

  test "create board redirects to the board" do
    assert_difference -> { Board.count }, 1 do
      post boards_url, params: { board: { title: "Fresh board" } }
    end
    assert_redirected_to board_url(Board.last)
  end

  test "create board without title shows errors" do
    assert_no_difference -> { Board.count } do
      post boards_url, params: { board: { title: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".error-explanation"
  end

  test "update board" do
    board = boards(:general)
    patch board_url(board), params: { board: { title: "Renamed" } }
    assert_redirected_to board_url(board)
    assert_equal "Renamed", board.reload.title
  end

  test "delete board" do
    assert_difference -> { Board.count }, -1 do
      delete board_url(boards(:general))
    end
    assert_redirected_to boards_url
  end
end
