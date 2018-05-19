module DCI
  class Configuration
    attr_accessor :transaction_class,
                  :event_routes,
                  :route_methods,
                  :raise_in_event_router,
                  :on_exception_in_router

    def initialize
      @transaction_class      = NullTransaction
      @event_routes           = Hash.new([])
      @route_methods          = nil
      @raise_in_event_router  = false
      @on_exception_in_router = -> (exception) { }
    end
  end
end
