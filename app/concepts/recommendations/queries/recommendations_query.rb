# frozen_string_literal: true

module Recommendations
  module Queries
    # Select perfect match results
    class RecommendationsQuery
      def self.call(brands, preferred_brands, price_range, preferred_price_range, user, offset, limit)
        perfect = find_perfect(brands, preferred_brands, price_range, preferred_price_range, user)
        good = find_good(brands, preferred_brands, price_range, preferred_price_range, user)
        ai = find_ai(brands, preferred_brands, user, price_range)
        rest = find_rest(preferred_brands, brands, user, price_range)

        Car.from("((#{perfect.to_sql}) " \
                 "UNION ALL (#{good.to_sql}) " \
                 "UNION ALL (#{ai.to_sql}) " \
                 "UNION ALL (#{rest.to_sql}) " \
                 "OFFSET #{offset} LIMIT #{limit}) AS cars")
      end

      def self.find_perfect(brands, preferred_brands, price_range, preferred_price_range, user)
        join_sql = ActiveRecord::Base.sanitize_sql(%(LEFT JOIN "ai_results"
                    ON "ai_results"."car_id" = "cars"."id"
                    AND "ai_results"."user_id" = #{user.id}))
        query = Car.where(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where(price: price_range)
             .where(price: preferred_price_range)
             .joins(join_sql)
             .select(
               'cars.*',
               'ai_results.rank_score as rank_score',
               "'perfect_match' as label"
             )
             .order(AiResult.arel_table[:rank_score].desc.nulls_last)
      end

      def self.find_good(brands, preferred_brands, price_range, preferred_price_range, user)
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
      end

      def self.find_ai(brands, preferred_brands, user, price_range)
        query = Car.where.not(brand: preferred_brands)
        query = query.where(brand: brands) if brands.present?
        query.where(price: price_range)
             .left_joins(:ai_result)
             .where(ai_results: { user: user, top: true })
             .select(
               'cars.*',
               'ai_results.rank_score as rank_score',
               'null as label'
             )
             .order(AiResult.arel_table[:rank_score].desc.nulls_last)
      end

      def self.find_rest(preferred_brands, brands, user, price_range)
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
      end
    end
  end
end
