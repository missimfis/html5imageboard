require "test_helper"

class PngImageTest < ActiveSupport::TestCase
  test "decodes a valid PNG data URI" do
    png = "#{PngImage::SIGNATURE}payload"
    encoded = Base64.strict_encode64(png)

    assert_equal png, PngImage.decode("#{PngImage::DATA_URI_PREFIX}#{encoded}")
  end

  test "rejects oversized data before decoding" do
    payload = Object.new
    payload.define_singleton_method(:bytesize) { PngImage::MAX_DATA_LENGTH + 1 }
    payload.define_singleton_method(:delete_prefix) do |*|
      raise "oversized payload was decoded"
    end

    assert_nil PngImage.decode(payload)
  end

  test "rejects encoded data above the decoded limit before decoding" do
    payload = Object.new
    payload.define_singleton_method(:bytesize) { PngImage::MAX_DATA_LENGTH }
    payload.define_singleton_method(:delete_prefix) do |*|
      "A" * (PngImage::MAX_ENCODED_BYTES + 1)
    end

    assert_nil PngImage.decode(payload)
  end

  test "rejects non-PNG data" do
    encoded = Base64.strict_encode64("hello")

    assert_nil PngImage.decode("#{PngImage::DATA_URI_PREFIX}#{encoded}")
  end
end
