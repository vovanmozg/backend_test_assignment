# frozen_string_literal: true

class RecommendedCarsController < ApplicationController
  before_action :validate_params

  def index
    content = Recommendations::Cars.new.list(params).as_json(
      only: %i[id model price rank_score label],
      include: { brand: {
        only: %i[id name]
      } }
    )

    render json: content
  rescue ArgumentError => e
    render json: { error: e.message }, status: :bad_request
  end

  def validate_params
    validator = Recommendations::CarsValidate.new(params)
    render json: { error: validator.errors } and return unless validator.valid?
  end
end
