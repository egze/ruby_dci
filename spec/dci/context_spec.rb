RSpec.describe DCI::Context do

  class DummyContext
    include DCI::Context

    def call
    end
  end

  describe "included modules" do

    [DCI::Accessor, DCI::Context, DCI::EventRouter].each do |mod|

      it "includes #{ mod }" do
        expect(DummyContext).to include(mod)
      end

    end

  end

  describe '#call' do

    let(:instance) { DummyContext.allocate }
    let(:arguments) { [1, 2, "foo"] }
    let(:keyword_arguments) { { a: 1, b: "foo"} }

    before do
      allow(DummyContext).to receive(:new).and_return(instance)
    end

    it "passes arguments to initializer" do
      DummyContext.call(*arguments)

      expect(DummyContext).to have_received(:new).with(*arguments)
    end

    it "passes keyword arguments to initializer" do
      DummyContext.call(**keyword_arguments)

      expect(DummyContext).to have_received(:new).with(**keyword_arguments)
    end

    it "calls perform_in_transaction on the instance" do
      allow(instance).to receive(:perform_in_transaction)

      DummyContext.call

      expect(instance).to have_received(:perform_in_transaction)
    end

  end

  describe "#perform_in_transaction" do

    subject(:instance) { DummyContext.new }
    let(:events) { spy("events") }

    it "calls call" do
      allow(instance).to receive(:call)

      instance.perform_in_transaction

      expect(instance).to have_received(:call)
    end

    it "calls init_context_events to set defaut value" do
      allow(instance).to receive(:init_context_events).and_call_original

      instance.perform_in_transaction

      expect(instance).to have_received(:init_context_events)
    end

    it "default events are an empty array" do
      expect(instance.send(:init_context_events)).to eq []
    end

    it "routes events" do
      allow(instance).to receive(:init_context_events).and_return(events)
      allow(instance).to receive(:route_events!)

      instance.perform_in_transaction

      expect(instance).to have_received(:route_events!).with(events)
    end

    it "clears events after execution" do
      allow(instance).to receive(:init_context_events).and_return(events)

      instance.perform_in_transaction

      expect(events).to have_received(:clear)
    end

    it "wraps code in transaction" do
      allow(instance).to receive(:call)
      allow(DCI).to receive_message_chain("configuration.transaction_class.transaction").and_yield

      instance.perform_in_transaction

      expect(instance).to have_received(:call)
    end

  end

end
