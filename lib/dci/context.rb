module DCI

  module Context

    include EventRouter
    include Accessor

    attr_accessor :events

    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods

      def perform_in_transaction
        old_context = context
        @events = init_context_events
        self.context = self

        res = nil

        DCI.configuration.transaction_class.transaction do
          res = call
        end

        route_events!(events)
        res
      ensure
        self.context = old_context
        self.events.clear
      end

      def context=(ctx)
        Thread.current[:context] = ctx
      end

      def call
        raise NotImplementedError.new("implement me")
      end

      private
      def init_context_events
        []
      end
    end

    module ClassMethods
      def call(*args)
        new(*args).perform_in_transaction
      end
    end

  end

end
