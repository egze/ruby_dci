require "dci/version"
require "dci/null_transaction"
require "dci/configuration"
require "dci/accessor"
require "dci/event_router"
require "dci/context"
require "dci/role"

module DCI
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
