RSpec.describe DCI::Configuration do
  subject(:instance) { DCI::Configuration.new }

  it { is_expected.to have_attr_accessor(:transaction_class) }
  it { is_expected.to have_attr_accessor(:routes) }
  it { is_expected.to have_attr_accessor(:router) }
  it { is_expected.to have_attr_accessor(:on_exception_in_router) }

  it "sets default transaction_class" do
    expect(instance.transaction_class).to eq DCI::NullTransaction
  end

  it "sets default event_routes" do
    expect(instance.routes).to be_a Hash
    expect(instance.routes.default).to eq []
  end

  it "sets default router" do
    expect(instance.router).to be_nil
  end

  it "sets default on_exception_in_router" do
    expect(instance.on_exception_in_router).to be_a Proc
  end
end
