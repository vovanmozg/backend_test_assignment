# frozen_string_literal: true

describe Recommendations::Cars do
  let(:page_size) { 20 }
  let(:params) { { user_id: 1 } }

  include_context 'stub external ai'

  shared_examples 'calls #list' do
    it 'returns results', :aggregate_failures do
      content = described_class.new(page_size).list(params)
      formatted = content.as_json(
        only: %i[id model price rank_score label],
        include: { brand: { only: %i[id name] } }
      )

      expect(content.map(&:id)).to eq(expected.map { |x| x['id'] })
      expect(formatted).to eq(expected)
    end
  end

  context 'with default page size' do
    let(:expected) { json_fixture('recommended_cars/common.json') }

    it_behaves_like 'calls #list'
  end

  context 'with non-existing user' do
    let(:params) { { user_id: 2 } }

    it 'raises error' do
      expect { described_class.new(page_size).list(params) }.to raise_error
    end
  end

  context 'with custom page size' do
    (1..20).each do |page|
      context "with page = #{page}" do
        let(:page_size) { 1 }
        let(:expected) { json_fixture('recommended_cars/common.json').slice(page - 1, 1) }
        let(:params) { { user_id: 1, page: page } }

        it_behaves_like 'calls #list'
      end
    end

    (1..10).each do |page|
      context "with page = #{page}" do
        let(:page_size) { 2 }
        let(:expected) { json_fixture('recommended_cars/common.json').slice((page - 1) * 2, 2) }
        let(:params) { { user_id: 1, page: page } }

        it_behaves_like 'calls #list'
      end
    end

    (1..6).each do |page|
      context "with page = #{page} and pagesize = 3" do
        let(:page_size) { 3 }
        let(:expected) { json_fixture('recommended_cars/common.json').slice((page - 1) * 3, 3) }
        let(:params) { { user_id: 1, page: page } }

        it_behaves_like 'calls #list'
      end
    end

    (1..5).each do |page|
      context "with page = #{page} and pagesize = 4" do
        let(:page_size) { 4 }
        let(:expected) { json_fixture('recommended_cars/common.json').slice((page - 1) * 4, 4) }
        let(:params) { { user_id: 1, page: page } }

        it_behaves_like 'calls #list'
      end
    end

    (1..4).each do |page|
      context "with page = #{page} and pagesize = 5" do
        let(:page_size) { 5 }
        let(:expected) { json_fixture('recommended_cars/common.json').slice((page - 1) * 5, 5) }
        let(:params) { { user_id: 1, page: page } }

        it_behaves_like 'calls #list'
      end
    end
  end

  context 'with query "Volks"' do
    let(:params) { { user_id: 1, query: 'Volks' } }
    let(:expected) { json_fixture('recommended_cars/query-volks.json') }

    it_behaves_like 'calls #list'
  end

  context 'with min price in params' do
    let(:params) { { user_id: 1, price_min: 35_000 } }
    let(:expected) { json_fixture('recommended_cars/min-35000.json') }

    it_behaves_like 'calls #list'
  end

  context 'with max price in params' do
    let(:params) { { user_id: 1, price_max: 35_000 } }
    let(:expected) { json_fixture('recommended_cars/max-35000.json') }

    it_behaves_like 'calls #list'
  end

  context 'with min and max price in params' do
    let(:params) { { user_id: 1, price_min: 37_000, price_max: 50_000 } }
    let(:expected) { json_fixture('recommended_cars/min-37000-max-50000.json') }

    it_behaves_like 'calls #list'
  end

  context 'with query and max price in params' do
    let(:params) { { user_id: 1, price_min: 50_000, query: 'ch' } }
    let(:expected) { json_fixture('recommended_cars/min-50000-query-ch.json') }

    it_behaves_like 'calls #list'
  end

  context 'with pagesize = 10000' do
    let(:page_size) { 10_000 }

    it 'contains only uniq values' do
      content = described_class.new(page_size).list(params)
      ids = content.map(&:id)
      expect(ids.count).to eq(ids.uniq.count)
    end
  end
end
