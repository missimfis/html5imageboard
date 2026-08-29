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
    assert_redirected_to board_url(@board)
  end

  test "create post without image shows alert" do
    assert_no_difference -> { @board.posts.count } do
      post board_posts_url(@board), params: { post: { title: "Sketch" } }
    end
    assert_redirected_to board_url(@board)
  end

  test "show a post" do
    get board_post_url(@board, posts(:hello))
    assert_response :success
    assert_select "h1", posts(:hello).title
  end

  test "update a post title" do
    post = posts(:hello)
    patch board_post_url(@board, post), params: { post: { title: "Renamed sketch" } }
    assert_redirected_to board_url(@board)
    assert_equal "Renamed sketch", post.reload.title
  end

  test "update a post with a new drawing" do
    post = posts(:hello)
    patch board_post_url(@board, post),
          params: { post: { title: "Redrawn" }, drawbox_data: "iVBORw0KGgoAAAANSUhEUg==" }
    assert_redirected_to board_url(@board)
    assert_equal "iVBORw0KGgoAAAANSUhEUg==", post.reload.svg
  end

  test "delete a post" do
    assert_difference -> { Post.count }, -1 do
      delete board_post_url(@board, posts(:hello))
    end
    assert_redirected_to board_url(@board)
  end

  test "image endpoint serves the post image" do
    get post_image_url(posts(:hello))
    assert_response :success
    assert_equal "image/png", response.media_type
  end
end
