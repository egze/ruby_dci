module DCI
  module EventRouter

    def route_events!(events)
      Array(events).each(&method(:route_event!))
    end

    private

    def route_event!(event)
      DCI.configuration.routes[event.class].each do |callback|
        dispatch_catching_standard_errors do
          DCI.configuration.router.send(callback, event)
        end
      end
    end

    def dispatch_catching_standard_errors
      begin
        yield
      rescue StandardError => exception
        DCI.configuration.on_exception_in_router.call(exception) rescue nil

        raise exception if DCI.configuration.raise_in_router
      end
    end

  end
end
