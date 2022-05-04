# frozen_string_literal: true

module Recommendations
  module Queries
    class AiResultsQuery
      def self.call(user)
        AiResult.where(user: user)
      end
    end
  end
end
