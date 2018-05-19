module DCI

  module EventRouter

    def route_events!(events)
      Array(events).each(&method(:route_event!))
    end

    private
    def route_event!(event)
      DCI.configuration.event_routes[event.class].each do |callback|
        dispatch_catching_standard_errors do
          DCI.configuration.route_methods.send(callback, event)
        end
      end
    end

    def dispatch_catching_standard_errors(&block)
      begin
        block.call
      rescue StandardError => exception
        DCI.configuration.on_exception_in_router.call(exception)
        raise exception if DCI.configuration.raise_in_event_router
      end
    end

  end

end
