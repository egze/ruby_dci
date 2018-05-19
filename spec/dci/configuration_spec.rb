RSpec.describe DCI::Configuration do

  subject(:instance) { DCI::Configuration.new }

  it { is_expected.to have_attr_accessor(:transaction_class) }
  it { is_expected.to have_attr_accessor(:event_routes) }
  it { is_expected.to have_attr_accessor(:route_methods) }
  it { is_expected.to have_attr_accessor(:raise_in_event_router) }
  it { is_expected.to have_attr_accessor(:logger) }

  it "sets default transaction_class" do
    expect(instance.transaction_class).to eq DCI::NullTransaction
  end

  it "sets default event_routes" do
    expect(instance.event_routes).to be_a Hash
    expect(instance.event_routes.default).to eq []
  end

  it "sets default route_methods" do
    expect(instance.route_methods).to be_nil
  end

  it "sets default logger" do
    expect(instance.logger).to be_nil
  end

  it "sets default raise_in_event_router" do
    expect(instance.raise_in_event_router).to eq false
  end

end
