# frozen_string_literal: true

describe Recommendations::Queries::FindGoodMatchQuery do
  let(:preferred_brands) { Brand.where(id: [2, 39]) }
  let(:brands) { [] }
  let(:preferred_price_range) { 35_000..40_000 }
  let(:user) { User.find(1) }
  let(:count) { described_class.count(preferred_brands, brands, price_range, preferred_price_range, user) }
  let(:records) do
    described_class.call(
      preferred_brands,
      brands,
      price_range,
      preferred_price_range,
      user,
      nil,
      0
    )
  end

  context 'when the price range end is in preferred price range' do
    let(:price_range) { ..37_000 }
    it { expect(records.to_a.size).to eq(count) }
  end

  context 'when the price range end less than preferred price range begin' do
    let(:price_range) { ..30_000 }
    it { expect(records.to_a.size).to eq(count) }
  end

  context 'when the price range end greater than preferred price range end' do
    let(:price_range) { ..50_000 }
    it { expect(records.to_a.size).to eq(count) }
  end
end
