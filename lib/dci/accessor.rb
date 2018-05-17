module DCI
  module Accessor

    def context
      Thread.current[:context]
    end

  end
end
