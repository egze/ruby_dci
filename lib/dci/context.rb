module DCI

  module Context

    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def perform_in_transaction
        old_context = context
        @events = []
        self.context = self

        res = nil

        ActiveRecord::Base.transaction do
          res = call
        end

        route_events!(events)
        res
      ensure
        self.context = old_context
        events.clear
      end

      def context=(ctx)
        Thread.current[:context] = ctx
      end

      def call
        raise NotImplementedError.new("implement me")
      end
    end

    module ClassMethods
      def call(*args)
        context_instance = new(*args)
        context_instance.perform_in_transaction
      end
    end

  end

end
