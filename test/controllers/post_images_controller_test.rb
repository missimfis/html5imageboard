require "test_helper"

class PostImagesControllerTest < ActionDispatch::IntegrationTest
  test "image endpoint serves the post image" do
    get post_image_url(posts(:hello))
    assert_response :success
    assert_equal "image/png", response.media_type
  end

  test "image endpoint returns not found for missing post" do
    get post_image_url(999_999_999)
    assert_response :not_found
  end

  test "image endpoint returns not found for undecodable data" do
    post = posts(:hello)
    post.update!(image_data: "not-a-png")
    get post_image_url(post)
    assert_response :not_found
  end

  test "image endpoint returns not found for non-PNG data" do
    post = posts(:hello)
    post.update!(image_data: "data:image/png;base64,aGVsbG8=")
    get post_image_url(post)
    assert_response :not_found
  end

  test "image endpoint rejects oversized encoded data" do
    post = posts(:hello)
    post.update_columns(image_data: "A" * (PngImage::MAX_DATA_LENGTH + 1)) # rubocop:disable Rails/SkipsModelValidations

    get post_image_url(post)

    assert_response :not_found
  end

  test "image endpoint sets long-lived cache headers" do
    get post_image_url(posts(:hello))
    assert_includes response.headers["Cache-Control"], "max-age="
    assert_includes response.headers["Cache-Control"], "immutable"
  end
end
