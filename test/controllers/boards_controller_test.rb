require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "index lists boards" do
    get boards_url
    assert_response :success
    assert_select "h1", "Boards"
    assert_select ".board-title", boards(:general).title
    assert_select ".board-meta", /2 posts/
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

    board = Board.find_by!(title: "Fresh board")
    assert_redirected_to board_url(board)
    assert board.owner_token.present?
  end

  test "create board without title shows errors" do
    assert_no_difference -> { Board.count } do
      post boards_url, params: { board: { title: "" } }
    end
    assert_response :unprocessable_content
    assert_select ".error-explanation"
  end

  test "does not update a board without ownership" do
    board = boards(:general)

    patch board_url(board), params: { board: { title: "Renamed" } }

    assert_redirected_to board_url(board)
    assert_equal "General Discussion", board.reload.title
  end

  test "owner can update their board" do
    board = create_owned_board

    patch board_url(board), params: { board: { title: "Renamed" } }

    assert_redirected_to board_url(board)
    assert_equal "Renamed", board.reload.title
  end

  test "does not render edit for a board without ownership" do
    get edit_board_url(boards(:general))
    assert_redirected_to board_url(boards(:general))
  end

  test "owner can render edit for their board" do
    board = create_owned_board
    get edit_board_url(board)
    assert_response :success
  end

  test "does not delete a board without ownership" do
    board = boards(:general)

    assert_no_difference -> { Board.count } do
      delete board_url(board)
    end

    assert_redirected_to board_url(board)
  end

  test "owner can delete their board" do
    board = create_owned_board

    assert_difference -> { Board.count }, -1 do
      delete board_url(board)
    end

    assert_redirected_to boards_url
  end

  test "index hides board controls from other sessions" do
    get boards_url

    assert_select "a[title='Edit board']", count: 0
    assert_select "button[title='Delete board']", count: 0
  end

  test "index shows board controls to the owner" do
    create_owned_board
    get boards_url

    assert_select "a[title='Edit board']", count: 1
    assert_select "button[title='Delete board']", count: 1
  end

  test "index renders pagination" do
    12.times { |i| Board.create!(title: "Board #{i}") }
    get boards_url
    assert_response :success
    assert_select "nav.pagy"
  end

  test "show renders pagination for many posts" do
    board = boards(:music)
    9.times { |i| Post.create!(board: board, title: "Post #{i}", image_data: "iVBORw0KGgo") }
    get board_url(board)
    assert_response :success
    assert_select "nav.pagy"
  end
end
