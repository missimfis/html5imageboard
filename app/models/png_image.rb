module PngImage
  DATA_URI_PREFIX = "data:image/png;base64,".freeze
  SIGNATURE = "\x89PNG\r\n\x1A\n".b.freeze
  MAX_DECODED_BYTES = 10.megabytes
  MAX_ENCODED_BYTES = 4 * ((MAX_DECODED_BYTES + 2) / 3)
  MAX_DATA_LENGTH = MAX_ENCODED_BYTES + DATA_URI_PREFIX.bytesize

  module_function

  def decode(image_data)
    return nil if image_data.blank?
    return nil if image_data.bytesize > MAX_DATA_LENGTH

    encoded = image_data.delete_prefix(DATA_URI_PREFIX)
    return nil if encoded.bytesize > MAX_ENCODED_BYTES

    valid_png(decode_base64(encoded))
  rescue ArgumentError
    nil
  end

  def decode_base64(encoded)
    encoded += "=" * ((4 - (encoded.length % 4)) % 4)
    Base64.strict_decode64(encoded)
  end

  def valid_png(png_data)
    return nil unless png_data.bytesize.between?(1, MAX_DECODED_BYTES)
    return nil unless png_data.start_with?(SIGNATURE)

    png_data
  end
end
