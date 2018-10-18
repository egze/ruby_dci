require 'rspec/support'

module DCI
  module Rspec
    module Helpers
      def dci_context!(**args)
        Thread.current[:context] = OpenStruct.new(args)
      end
    end
  end
end

RSpec.configure do |config|
  config.include DCI::Rspec::Helpers

  config.after do
    Thread.current[:context] = nil
  end
end
