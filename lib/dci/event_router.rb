module DCI

  module EventRouter

    private
    def route_events!(events)
      Array(events).each(&method(:route_event!))
    end

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
      rescue StandardError => e
        if DCI.configuration.logger
          DCI.configuration.logger.error "Failed to dispatch event (transaction was still commited). #{ e }"
        end
        raise e if DCI.configuration.raise_in_event_router
      end
    end

  end

end