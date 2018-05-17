module DCI
  class NullTransaction
    def self.transaction
      yield
    end
  end
end
