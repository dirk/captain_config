# Using the `rack.after_reply` hook provided by Puma for running code after
# the response has been sent to the client.
class CaptainConfig::PumaMiddleware
  RACK_AFTER_REPLY = ::Puma::Const::RACK_AFTER_REPLY

  def initialize(app)
    @app = app
  end

  def call(env)
    service = CaptainConfig::Service.last_created_service

    if service
      # Load if it hasn't already been loaded (eg. first request).
      service.load unless service.loaded?

      # Then reload after every request.
      env[RACK_AFTER_REPLY] << lambda { service.load }
    end

    @app.call env
  end
end
