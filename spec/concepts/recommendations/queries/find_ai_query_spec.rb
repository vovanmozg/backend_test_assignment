# frozen_string_literal: true

describe Recommendations::Queries::FindAiQuery do
  let(:preferred_brands) { Brand.where(id: [2, 39]) }
  let(:brands) { [] }
  let(:user) { User.find(1) }
  let(:price_range) { nil..nil }
  let(:count) { described_class.count(preferred_brands, brands, user, price_range) }
  let(:records) do
    described_class.call(
      preferred_brands,
      brands,
      user,
      price_range,
      nil,
      0
    )
  end

  it { expect(records.to_a.size).to eq(count) }
end

# We can remove query objects specs because cars_spec.rb covers this
# functionality
