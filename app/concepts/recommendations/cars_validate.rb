# frozen_string_literal: true

module Recommendations
  # Validate REST params
  class CarsValidate
    include ActiveModel::Validations

    attr_accessor :user_id, :price_min, :price_max, :query

    validates :user_id, numericality: true, presence: true
    validates :price_min, allow_nil: true, numericality: true
    validates :price_max, allow_nil: true, numericality: true
    validates :query, length: { maximum: 500 }

    def initialize(params = {})
      @user_id = params[:user_id]
      @price_min = params[:price_min]
      @price_max = params[:price_max]
      @query = params[:query]
      params.require(:user_id)
    end
  end
end
