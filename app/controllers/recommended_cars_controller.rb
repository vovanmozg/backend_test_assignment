# frozen_string_literal: true

class RecommendedCarsController < ApplicationController
  def index
    content = Recommendations::Cars.new.list(search_params).as_json(
      only: %i[id model price rank_score label],
      include: { brand: {
        only: %i[id name]
      } }
    )

    render json: content
  end

  def search_params
    params.require(:user_id)
    params.permit(:user_id, :query, :price_min, :price_max, :page)
  end
end
