require "bundler/setup"
require "dci"
require "pry"

require "examples/boy"
require "examples/domain_events"
require "examples/route_method_store"
require "examples/student"
require "examples/do_homework"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do

    DCI.configure do |config|
      config.event_routes.store DomainEvents::HomeworkDone, [ :publish_homework_done ]
      config.route_methods = RouteMethodStore.new
    end

  end
end
