module DCI
  class Configuration
    attr_accessor :transaction_class,
                  :event_routes,
                  :route_methods,
                  :raise_in_event_router,
                  :logger

    def initialize
      @transaction_class      = NullTransaction
      @event_routes           = Hash.new([])
      @route_methods          = nil
      @raise_in_event_router  = false
      @logger                 = nil
    end
  end
end
