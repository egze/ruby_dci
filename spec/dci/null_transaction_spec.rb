RSpec.describe DCI::NullTransaction do

  subject(:described_class) { DCI::NullTransaction }

  it "executes block in transaction" do
    result = []

    described_class.transaction do
      result << 1
    end

    expect(result).to eq [1]
  end

end
