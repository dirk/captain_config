module CaptainConfig::SidekiqMiddlewareFactory
  # Since Sidekiq calls `.new` on the middleware class for every job we cannot
  # store state in the instance between jobs like we would with a Rack
  # middleware. Therefore we need to build a new class to hold that state.
  #
  # interval: - Minimum time (in seconds) that must pass between reloading
  #             configuration.
  def self.build(interval: 1.0)
    klass = Class.new do
      include SidekiqMiddleware
    end
    klass.setup(interval: interval)
    klass
  end

  module SidekiqMiddleware
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :interval, :last_loaded_at

      def setup(interval:)
        @interval = interval
        @mutex = Mutex.new
        @last_loaded_at = Time.at(0)
      end

      def needs_load?
        (Time.now - @last_loaded_at) >= @interval
      end

      def load
        @mutex.synchronize do
          # The instances of the middleware on each thread call `#needs_load?`
          # unsynchronized, so they may think a reload is needed when it isn't.
          return unless needs_load?

          service = CaptainConfig::Service.last_created_service
          service&.load

          @last_loaded_at = Time.now
        end
      end
    end

    def call(_worker, _job, _queue)
      yield

      self.class.load if self.class.needs_load?
    end
  end
end
