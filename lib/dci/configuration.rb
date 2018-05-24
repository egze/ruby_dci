module DCI
  class Configuration

    attr_accessor :transaction_class,
                  :routes,
                  :router,
                  :on_exception_in_router,
                  :raise_in_router

    def initialize
      @transaction_class      = NullTransaction
      @routes                 = Hash.new([])
      @router                 = nil
      @raise_in_router        = false
      @on_exception_in_router = -> (exception) {}
    end

  end
end
