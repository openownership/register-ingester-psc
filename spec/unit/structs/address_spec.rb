require 'register_ingester_psc/structs/address'

RSpec.describe RegisterIngesterPsc::Address do
  subject { described_class.new(**fields) }

  let(:fields) do
    {
      type: RegisterIngesterPsc::AddressTypes['registered'],
      address: "Some address",
      postCode: "CA1 3CD",
      country: "GB"
    }
  end

  it 'creates struct without errors' do
    expect(subject).to be_a RegisterIngesterPsc::Address
  end
end
