require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @board = boards(:general)
  end

  test "create post with drawn image" do
    assert_difference -> { @board.posts.count }, 1 do
      post board_posts_url(@board),
           params: { post: { title: "Sketch", description: "hi" }, drawbox_data: "data:image/png;base64,aGVsbG8=" }
    end

    created_post = @board.posts.find_by!(title: "Sketch")
    assert_redirected_to board_url(@board)
    assert created_post.owner_token.present?
  end

  test "create post without image re-renders the board with errors" do
    assert_no_difference -> { @board.posts.count } do
      post board_posts_url(@board), params: { post: { title: "Sketch" } }
    end
    assert_response :unprocessable_content
    assert_select ".error-explanation"
    assert_select "#new_post_form:not([hidden])"
  end

  test "show a post" do
    get board_post_url(@board, posts(:hello))
    assert_response :success
    assert_select "h1", posts(:hello).title
  end

  test "does not update a post without ownership" do
    post_record = posts(:hello)

    patch board_post_url(@board, post_record), params: { post: { title: "Renamed sketch" } }

    assert_redirected_to board_url(@board)
    assert_equal "First post", post_record.reload.title
  end

  test "owner can update their post title" do
    post_record = create_owned_post(@board, title: "Sketch")

    patch board_post_url(@board, post_record), params: { post: { title: "Renamed sketch" } }

    assert_redirected_to board_url(@board)
    assert_equal "Renamed sketch", post_record.reload.title
  end

  test "owner can update a post with a new drawing" do
    post_record = create_owned_post(@board, title: "Sketch")

    patch board_post_url(@board, post_record),
          params: { post: { title: "Redrawn" }, drawbox_data: "iVBORw0KGgoAAAANSUhEUg==" }

    assert_redirected_to board_url(@board)
    assert_equal "iVBORw0KGgoAAAANSUhEUg==", post_record.reload.image_data
  end

  test "does not render edit for a post without ownership" do
    get edit_board_post_url(@board, posts(:hello))
    assert_redirected_to board_url(@board)
  end

  test "owner can render edit for their post" do
    post_record = create_owned_post(@board, title: "Sketch")
    get edit_board_post_url(@board, post_record)
    assert_response :success
  end

  test "does not delete a post without ownership" do
    assert_no_difference -> { Post.count } do
      delete board_post_url(@board, posts(:hello))
    end
    assert_redirected_to board_url(@board)
  end

  test "owner can delete their post" do
    post_record = create_owned_post(@board, title: "Sketch")

    assert_difference -> { Post.count }, -1 do
      delete board_post_url(@board, post_record)
    end

    assert_redirected_to board_url(@board)
  end

  test "another session cannot delete an owned post" do
    post_record = create_owned_post(@board, title: "Mine")
    other_session = open_session

    assert_no_difference -> { Post.count } do
      other_session.delete board_post_url(@board, post_record)
    end

    other_session.assert_redirected_to board_url(@board)
  end

  test "board page hides post controls from other sessions" do
    get board_url(@board)

    assert_select "a[title='Edit post']", count: 0
    assert_select "button[title='Delete post']", count: 0
  end

  test "board page shows post controls to the owner" do
    create_owned_post(@board, title: "Sketch")
    get board_url(@board)

    assert_select "a[title='Edit post']", count: 1
    assert_select "button[title='Delete post']", count: 1
  end
end
