class RequestBodyLimit
  DEFAULT_MAX_BYTES = 16 * 1024 * 1024

  class BodyTooLarge < StandardError; end

  def initialize(app, max_bytes: DEFAULT_MAX_BYTES)
    @app = app
    @max_bytes = max_bytes
  end

  def call(env)
    return payload_too_large if content_length(env) > @max_bytes

    env["rack.input"] = LimitedInput.new(env["rack.input"], @max_bytes) if env["rack.input"]
    @app.call(env)
  rescue BodyTooLarge
    payload_too_large
  end

  private

  def content_length(env)
    Integer(env["CONTENT_LENGTH"].to_s, 10)
  rescue ArgumentError
    0
  end

  def payload_too_large
    body = "Request body too large\n"
    [
      413,
      {
        "content-type" => "text/plain; charset=utf-8",
        "content-length" => body.bytesize.to_s
      },
      [body]
    ]
  end

  class LimitedInput
    def initialize(input, max_bytes)
      @input = input
      @max_bytes = max_bytes
      @bytes_read = 0
    end

    def read(length = nil, buffer = nil)
      track(@input.read(length, buffer))
    end

    def gets(*)
      track(@input.gets(*))
    end

    def each
      return enum_for(:each) unless block_given?

      while (line = gets)
        yield line
      end
    end

    def rewind
      @bytes_read = 0
      @input.rewind
    end

    def method_missing(name, *, &)
      return super unless @input.respond_to?(name)

      @input.public_send(name, *, &)
    end

    def respond_to_missing?(name, include_private = false)
      @input.respond_to?(name, include_private) || super
    end

    private

    def track(data)
      if data
        @bytes_read += data.bytesize
        raise BodyTooLarge if @bytes_read > @max_bytes
      end

      data
    end
  end
end
