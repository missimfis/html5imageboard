require "test_helper"
require "stringio"

class RequestBodyLimitTest < ActiveSupport::TestCase
  test "rejects requests whose content length exceeds the limit" do
    middleware = RequestBodyLimit.new(->(_env) { [200, {}, ["ok"]] }, max_bytes: 10)

    status, _, body = middleware.call(
      "CONTENT_LENGTH" => "11",
      "rack.input" => StringIO.new("x" * 11)
    )

    assert_equal 413, status
    assert_equal "Request body too large\n", body.join
  end

  test "rejects chunked bodies that grow beyond the limit" do
    app = lambda do |env|
      env["rack.input"].read
      [200, {}, ["ok"]]
    end
    middleware = RequestBodyLimit.new(app, max_bytes: 10)

    status, = middleware.call(
      "CONTENT_LENGTH" => nil,
      "rack.input" => StringIO.new("x" * 11)
    )

    assert_equal 413, status
  end

  test "passes through bodies within the limit" do
    app = ->(env) { [200, {}, [env["rack.input"].read]] }
    middleware = RequestBodyLimit.new(app, max_bytes: 10)

    status, _, body = middleware.call(
      "CONTENT_LENGTH" => "5",
      "rack.input" => StringIO.new("hello")
    )

    assert_equal 200, status
    assert_equal "hello", body.join
  end
end
