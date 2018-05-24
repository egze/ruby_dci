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

    class Router

      def after_dummy_event(event)
      end

      def another_after_dummy_event(event)
      end

    end

    let(:router) { Router.new }
    let(:event) { Events::DummyEvent.new(1) }

    before do
      DCI.configure do |config|
        config.routes = Hash.new([])
        config.routes.store Events::DummyEvent, [:after_dummy_event, :another_after_dummy_event]

        config.router = router
      end
    end

    it "routes event" do
      allow(router).to receive(:after_dummy_event)
      allow(router).to receive(:another_after_dummy_event)

      instance.route_events!([event])

      expect(router).to have_received(:after_dummy_event).with(event).ordered
      expect(router).to have_received(:another_after_dummy_event).with(event).ordered
    end

    context "exceptions" do
      before do
        allow(router).to receive(:after_dummy_event).and_raise(StandardError)
      end

      context "should raise" do
        let(:logger) { instance_double("logger", error: nil) }

        before do
          DCI.configure do |config|
            config.routes = Hash.new([])
            config.routes.store Events::DummyEvent, [:after_dummy_event, :another_after_dummy_event]

            config.router = router
            config.raise_in_router = true
            config.on_exception_in_router = -> (ex) do
              logger.error(ex)
            end
          end
        end

        it "raises exception" do
          expect { instance.route_events!([event]) }.to raise_error(StandardError)
        end

        it "calls on_exception_in_router callback" do
          allow(DCI.configuration).to receive(:on_exception_in_router)

          expect { instance.route_events!([event]) }.to raise_error(StandardError)

          expect(DCI.configuration).to have_received(:on_exception_in_router)
        end

        it "on_exception_in_router lambda is executed" do
          expect { instance.route_events!([event]) }.to raise_error(StandardError)

          expect(logger).to have_received(:error).with(StandardError)
        end
      end

      context "should not raise" do
        before do
          DCI.reset

          DCI.configure do |config|
            config.routes = Hash.new([])
            config.routes.store Events::DummyEvent, [:after_dummy_event, :another_after_dummy_event]
            config.raise_in_router = false
            config.router = router
          end
        end

        it "rescues exception" do
          expect { instance.route_events!([event]) }.not_to raise_error
        end
      end
    end
  end
end
