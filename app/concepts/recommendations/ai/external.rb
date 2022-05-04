# frozen_string_literal: true

module Recommendations
  module Ai
    # External API adapter
    class External
      def self.fetch(user_id)
        url = "#{ENV['EXT_AI_SERVICE']}?user_id=#{user_id}"
        response = Excon.get(url)
        JSON.parse(response.body)

        # Temporary hardcode AI recommendations, because service
        # returns invalid data (duplicate car id 5)
        [
          { 'car_id' => 179, 'rank_score' => 0.945 },
          { 'car_id' => 5, 'rank_score' => 0.4552 },
          { 'car_id' => 180, 'rank_score' => 0.567 },
          { 'car_id' => 97, 'rank_score' => 0.9489 },
          { 'car_id' => 86, 'rank_score' => 0.2183 },
          { 'car_id' => 32, 'rank_score' => 0.0967 },
          { 'car_id' => 176, 'rank_score' => 0.0353 },
          { 'car_id' => 177, 'rank_score' => 0.1657 },
          { 'car_id' => 186, 'rank_score' => 0.7068 },
          { 'car_id' => 103, 'rank_score' => 0.4729 }
        ]
      end

      def self.sorted(user)
        fetch(user.id).sort_by { |item| item['rank_score'] }.reverse!
      end
    end
  end
end
