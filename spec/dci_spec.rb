RSpec.describe DCI do
  it "has a version number" do
    expect(DCI::VERSION).not_to be nil
  end


  describe DCI::Context do

    it "calls call on the instance" do
      expect_any_instance_of(DoHomework).to receive(:call)

      DoHomework.call(boy: Boy.new)
    end

  end
end
