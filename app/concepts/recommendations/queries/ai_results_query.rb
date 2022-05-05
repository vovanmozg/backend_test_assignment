# frozen_string_literal: true

module Recommendations
  module Queries
    # Results of external recommendation service for certain user
    class AiResultsQuery
      def self.call(user)
        AiResult.where(user: user)
      end
    end
  end
end
