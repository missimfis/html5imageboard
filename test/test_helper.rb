ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def create_owned_board(title: "Owned board")
      post boards_url, params: { board: { title: title } }
      Board.find_by!(title: title)
    end

    def create_owned_post(board, title: "Owned post", image_data: "iVBORw0KGgo")
      post board_posts_url(board),
           params: { post: { title: title }, drawbox_data: image_data }
      board.posts.find_by!(title: title)
    end

    def with_moderator_password(password)
      previous = ENV.fetch("MODERATOR_PASSWORD", nil)
      ENV["MODERATOR_PASSWORD"] = password
      yield
    ensure
      ENV["MODERATOR_PASSWORD"] = previous
    end
  end
end
