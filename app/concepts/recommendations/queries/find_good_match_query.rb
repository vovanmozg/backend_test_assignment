# frozen_string_literal: true

module Recommendations
  module Queries
    # Select good match results
    class FindGoodMatchQuery
      def self.call(brands, preferred_brands, price_range, preferred_price_range, user, limit, offset)
        join_sql = ActiveRecord::Base.sanitize_sql(%(LEFT JOIN "ai_results"
                    ON "ai_results"."car_id" = "cars"."id"
                    AND "ai_results"."user_id" = #{user.id}))
        query = Car.where(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where.not(price: preferred_price_range)
             .where(price: price_range)
             .joins(join_sql)
             .select(
               'cars.*',
               'ai_results.rank_score as rank_score',
               "'good_match' as label"
             )
             .order(AiResult.arel_table[:rank_score].desc.nulls_last)
             .limit(limit)
             .offset(offset)
      end

      def self.count(brands, preferred_brands, price_range, preferred_price_range, user)
        join_sql = ActiveRecord::Base.sanitize_sql(%(LEFT JOIN "ai_results"
                    ON "ai_results"."car_id" = "cars"."id"
                    AND "ai_results"."user_id" = #{user.id}))
        query = Car.where(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where.not(price: preferred_price_range)
             .where(price: price_range)
             .joins(join_sql)
             .count
      end
    end
  end
end
