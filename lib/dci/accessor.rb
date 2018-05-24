module DCI
  module Accessor

    def context
      Thread.current[:context]
    end

    def context_events
      Thread.current[:context_events]
    end

  end
end
