RSpec.describe DCI::EventRouter do

  class DummyClassWithRouter
    include DCI::EventRouter
  end

  subject(:instance) { DummyClassWithRouter.new }

  it "calls route_event! for each event" do
    allow(instance).to receive(:route_event!)
    events = [1, 2]

    instance.route_events! events

    expect(instance).to have_received(:route_event!).with(1).ordered
    expect(instance).to have_received(:route_event!).with(2).ordered
  end

  context "with route method store" do

    module Events
      DummyEvent = Struct.new(:id)
    end

    class RouteMethodStore
      def after_dummy_event(event)
      end

      def another_after_dummy_event(event)
      end
    end

    let(:route_method_store) { RouteMethodStore.new }
    let(:event) { Events::DummyEvent.new(1) }

    before do
      DCI.configure do |config|
        config.event_routes = Hash.new([])
        config.event_routes.store Events::DummyEvent, [ :after_dummy_event, :another_after_dummy_event ]

        config.route_methods = route_method_store
        config.raise_in_event_router = true
      end
    end

    it "routes event" do
      allow(route_method_store).to receive(:after_dummy_event)
      allow(route_method_store).to receive(:another_after_dummy_event)

      instance.route_events!([event])

      expect(route_method_store).to have_received(:after_dummy_event).with(event).ordered
      expect(route_method_store).to have_received(:another_after_dummy_event).with(event).ordered
    end

  end

end
