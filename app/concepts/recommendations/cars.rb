# frozen_string_literal: true

module Recommendations
  # Implements recommendation business logic
  class Cars
    DEFAULT_PAGE_SIZE = 20

    def initialize(page_size = DEFAULT_PAGE_SIZE)
      @page_size = page_size
    end

    # @param options [Hash] contains query, price_min, price_max, page
    def list(options)
      options = prepare_params(options)
      user = options[:user]

      Ai::PrepareService.new.call(user)

      Queries::RecommendationsQuery.call(
        options[:brands],
        options[:preferred_brands],
        options[:price_range],
        options[:preferred_price_range],
        options[:user],
        @page_size * (options[:page] - 1),
        @page_size
      )
    end

    def prepare_params(options)
      user_id = options.fetch(:user_id)
      user = User.where(id: user_id).first
      raise ArgumentError, I18n.t('recommendations.user_not_found') if user.blank?

      page = options.fetch(:page, 1).to_i
      brand_query = options.fetch(:query, nil)
      price_min = options.fetch(:price_min, nil)
      price_max = options.fetch(:price_max, nil)

      {
        page: page,
        brands: brand_query.present? ? Queries::BrandsBySubStringQuery.call(brand_query).pluck(:id) : [],
        preferred_brands: user.preferred_brands.pluck(:id),
        price_range: price_min..price_max,
        preferred_price_range: user.preferred_price_range,
        user: user,
        query: brand_query,
        page_size: @page_size,
        offset: @page_size * (page - 1)
      }
    end
  end
end
