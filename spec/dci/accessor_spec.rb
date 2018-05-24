RSpec.describe DCI::Accessor do
  class DummyObject

    include DCI::Accessor

  end

  subject(:instance) { DummyObject.new }

  it "adds context accessor" do
    expect(instance).to respond_to(:context)
  end

  it "reads from context" do
    Thread.current[:context] = "foo"
    expect(instance.context).to eq "foo"
  end
end
