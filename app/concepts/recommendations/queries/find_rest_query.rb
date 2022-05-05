# frozen_string_literal: true

module Recommendations
  module Queries
    # Select results which was not included in other groups
    class FindRestQuery
      def self.call(preferred_brands, brands, user, price_range, limit, offset)
        query = Car.where.not(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where(price: price_range)
             .joins(ActiveRecord::Base.sanitize_sql(%(LEFT JOIN "ai_results"
                    ON "ai_results"."car_id" = "cars"."id"
                    AND "ai_results"."user_id" = #{user.id})))
             .where(ai_results: { top: nil })
             .select(
               'cars.*',
               'ai_results.rank_score AS rank_score',
               'null AS label'
             )
             .order(price: :asc)
             .offset(offset)
             .limit(limit)
      end
    end
  end
end
