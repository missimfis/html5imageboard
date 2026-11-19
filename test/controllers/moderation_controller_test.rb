require "test_helper"

class ModerationControllerTest < ActionDispatch::IntegrationTest
  test "moderation page renders the password form when configured" do
    with_moderator_password("secret") do
      get new_moderation_url

      assert_response :success
      assert_select "h1", "Moderation"
      assert_select "input[type='password']"
    end
  end

  test "moderation page explains when it is not configured" do
    with_moderator_password(nil) do
      get new_moderation_url

      assert_response :success
      assert_select "h1", "Moderation"
      assert_match "not configured", response.body
    end
  end

  test "moderator sees the signed-in state" do
    with_moderator_password("secret") do
      post moderation_url, params: { password: "secret" }
      get new_moderation_url

      assert_response :success
      assert_select "button", text: "Exit moderation"
    end
  end

  test "moderator can update any board" do
    with_moderator_password("secret") do
      post moderation_url, params: { password: "secret" }
      assert_redirected_to boards_url

      patch board_url(boards(:general)), params: { board: { title: "Moderated" } }

      assert_redirected_to board_url(boards(:general))
      assert_equal "Moderated", boards(:general).reload.title
    end
  end

  test "moderator can delete any post" do
    with_moderator_password("secret") do
      post moderation_url, params: { password: "secret" }

      assert_difference -> { Post.count }, -1 do
        delete board_post_url(boards(:general), posts(:hello))
      end

      assert_redirected_to board_url(boards(:general))
    end
  end

  test "wrong moderation password does not grant access" do
    with_moderator_password("secret") do
      post moderation_url, params: { password: "wrong" }
      assert_redirected_to new_moderation_url

      patch board_url(boards(:general)), params: { board: { title: "Hijacked" } }

      assert_equal "General Discussion", boards(:general).reload.title
    end
  end
end
