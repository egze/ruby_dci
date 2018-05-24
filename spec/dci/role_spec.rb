RSpec.describe DCI::Role do
  describe "included modules" do
    [DCI::Accessor].each do |mod|
      it "includes #{ mod }" do
        expect(DCI::Role).to include(mod)
      end
    end
  end
end
