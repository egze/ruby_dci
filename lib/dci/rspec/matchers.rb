require 'rspec/support'
RSpec::Support.require_rspec_support 'matcher_definition'

RSpec.configure do |config|
  config.before do
    Thread.current[:context_events] = []
  end

  config.after do
    Thread.current[:context_events] = nil
  end
end

RSpec::Matchers.define :include_context_event do |expected_context_event|
  match do |object|
    object.context_events.map(&:class).include?(expected_context_event)
  end

  failure_message do |object|
    "expected context_events (#{ object.context_events.map(&:class).map(&:name) }) to include #{ expected_context_event.name }"
  end
end
