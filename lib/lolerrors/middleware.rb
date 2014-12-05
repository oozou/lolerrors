module Lolerrors
  class Middleware
    def initialize(app)
      @app = app

      @adapter = ::Lolerrors::Adapter.get_adapter
    end

    def call(env)
      @app.call env
    rescue => e
      capture e
    end

  private
    def capture(exception)
      @adapter.capture exception.message.truncate(32)
      raise exception
    end
  end
end
