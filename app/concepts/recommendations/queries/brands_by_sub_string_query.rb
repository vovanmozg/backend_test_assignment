# frozen_string_literal: true

module Recommendations
  module Queries
    # Processes in tens of milliseconds for 1_000_000 records. We can
    # speed up it with full text search, or perhaps separated table with
    # all substrings for all brands
    class BrandsBySubStringQuery
      def self.call(query)
        Brand.where('name ILIKE ?', "%#{query.downcase}%")
      end
    end
  end
end
