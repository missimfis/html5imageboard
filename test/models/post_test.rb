require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "title and svg are required" do
    post = Post.new
    assert_not post.valid?
    assert post.errors.added?(:title, :blank)
    assert post.errors.added?(:svg, :blank)
  end

  test "belongs to a board" do
    assert_equal boards(:general), posts(:hello).board
  end

  test "newest scope orders by creation date descending" do
    assert_equal Post.order(created_at: :desc).to_a, Post.newest.to_a
  end
end
