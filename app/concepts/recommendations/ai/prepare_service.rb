# frozen_string_literal: true

module Recommendations
  module Ai
    # Fetches recommendations from external AI service and caches
    # for a day
    class PrepareService
      def call(user)
        records = Queries::AiResultsQuery.call(user)
        return if actual_cache?(records)

        # Clear cache
        records.delete_all

        data = Ai::External.sorted(user)
        top_count = 5
        # top as nil - for using with join
        data = data.map.with_index do |row, index|
          is_top = index < top_count ? true : nil
          row.merge(user_id: user.id, top: is_top)
        end
        AiResult.upsert_all(data)
      end

      def actual_cache?(records)
        expiration_date = Time.now - 1.day
        records.any? { |rec| rec.created_at > expiration_date }
      end
    end
  end
end

# To get rid of first query delay we can daily update AiResult for
# all users in the background job
