module DCI
  class Configuration
    attr_accessor :transaction_class, :event_routes, :route_methods

    def initialize
      @transaction_class = NullTransaction
      @event_routes = Hash.new([])
      @route_methods = nil
    end
  end
end
