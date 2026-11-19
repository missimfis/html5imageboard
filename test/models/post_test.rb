require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "title and image data are required" do
    post = Post.new
    assert_not post.valid?
    assert post.errors.added?(:title, :blank)
    assert post.errors.added?(:image_data, :blank)
  end

  test "title and description are normalized" do
    post = Post.new(title: "  Hello   world ", description: "  some notes  ")
    assert_equal "Hello world", post.title
    assert_equal "some notes", post.description
  end

  test "title has a maximum length" do
    post = Post.new(title: "a" * (Post::TITLE_MAX_LENGTH + 1))
    assert_not post.valid?
    assert post.errors.added?(:title, :too_long, count: Post::TITLE_MAX_LENGTH)
  end

  test "image data has a maximum length" do
    post = Post.new(
      title: "Too large",
      image_data: "A" * (PngImage::MAX_DATA_LENGTH + 1)
    )
    assert_not post.valid?
    assert post.errors.added?(:image_data, :too_long, count: PngImage::MAX_DATA_LENGTH)
  end

  test "belongs to a board" do
    assert_equal boards(:general), posts(:hello).board
  end

  test "counter cache tracks posts" do
    board = boards(:music)
    post = nil

    assert_difference -> { board.reload.posts_count }, 1 do
      post = board.posts.create!(title: "Counted", image_data: "iVBORw0KGgo")
    end

    assert_difference -> { board.reload.posts_count }, -1 do
      post.destroy
    end
  end

  test "touching a post updates the board activity timestamp" do
    board = boards(:general)
    board.update!(updated_at: 1.week.ago)

    assert_changes -> { board.reload.updated_at } do
      posts(:hello).update!(title: "Fresh title")
    end
  end

  test "newest scope orders by creation date descending" do
    assert_equal Post.order(created_at: :desc, id: :desc).to_a, Post.newest.to_a
  end
end
