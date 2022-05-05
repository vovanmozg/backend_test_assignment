# frozen_string_literal: true

module Recommendations
  module Queries
    # Selected results from recommendation service
    class FindAiQuery
      def self.call(brands, preferred_brands, user, price_range, limit, offset)
        query = Car.where.not(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where(price: price_range)
             .left_joins(:ai_result)
             .where(ai_results: { user: user, top: true })
             .select('cars.*', 'ai_results.rank_score as rank_score', 'null as label')
             .order(AiResult.arel_table[:rank_score].desc.nulls_last)
             .offset(offset)
             .limit(limit)
      end

      def self.count(brands, preferred_brands, user, price_range)
        query = Car.where.not(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where(price: price_range)
             .left_joins(:ai_result)
             .where(ai_results: { user: user, top: true })
             .count
      end
    end
  end
end
