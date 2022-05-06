# frozen_string_literal: true

module Recommendations
  # Implements recommendation business logic
  class Cars
    # class ParamsError < ArgumentError; end

    DEFAULT_PAGE_SIZE = 20

    def initialize(page_size = DEFAULT_PAGE_SIZE)
      @page_size = page_size
    end

    # @param options [Hash] contains query, price_min, price_max, page
    def list(options)
      options = prepare_params(options)
      user = options[:user]

      Ai::PrepareService.new.call(user)

      results = []
      append(results, :perfect_match, options)
      append(results, :good_match, options)
      append(results, :ai, options)
      append(results, :rest, options)
      results.sum { |group| group[:records] }.take(@page_size)
    end

    # Each call appends results to array. Mutates results. Considers
    # existing records when generates new ones
    def append(results, strategy, options)
      offset = calculate_offset(results, options[:page], @page_size)
      return [] if offset.nil?

      # TODO: It would be better to set exact limit but not maximum
      results << {
        records: send("find_#{strategy}", **options.merge(offset: offset, limit: @page_size)),
        count_all: send("find_#{strategy}_count_all", **options)
      }
    end

    def calculate_offset(results, page, page_size)
      # How many items of other type already selected
      got_current_page_count = results.sum { |rec| rec[:records].size }

      # Break if there are enough results for current page
      return nil if got_current_page_count == page_size
      return 0 if got_current_page_count.positive?

      # If items of current type have not selected on current page, then
      # perhaps they had displayed on the previous page. Lets calculate
      # offset

      # How many items for types on previous pages.
      showed_prev_types_count = results.sum { |record| record[:count_all] }
      # How many items there are on previous pages
      skip_count = @page_size * (page - 1)
      # How many items of current type there are on previous pages
      skip_count - showed_prev_types_count
    end

    def find_perfect_match(params)
      Queries::FindPerfectMatchQuery.call(
        params[:brands],
        params[:preferred_brands],
        params[:price_range],
        params[:preferred_price_range],
        params[:user],
        params[:limit],
        params[:offset]
      )
    end

    def find_perfect_match_count_all(params)
      Queries::FindPerfectMatchQuery.count(
        params[:brands],
        params[:preferred_brands],
        params[:price_range],
        params[:preferred_price_range],
        params[:user]
      )
    end

    def find_good_match(params)
      Queries::FindGoodMatchQuery.call(
        params[:brands],
        params[:preferred_brands],
        params[:price_range],
        params[:preferred_price_range],
        params[:user],
        params[:limit],
        params[:offset]
      )
    end

    def find_good_match_count_all(params)
      Queries::FindGoodMatchQuery.count(
        params[:brands],
        params[:preferred_brands],
        params[:price_range],
        params[:preferred_price_range],
        params[:user]
      )
    end

    def find_ai(params)
      Recommendations::Queries::FindAiQuery.call(
        params[:brands],
        params[:preferred_brands],
        params[:user],
        params[:price_range],
        params[:limit],
        params[:offset]
      )
    end

    def find_ai_count_all(params)
      Recommendations::Queries::FindAiQuery.count(
        params[:brands],
        params[:preferred_brands],
        params[:user],
        params[:price_range]
      )
    end

    def find_rest(params)
      Recommendations::Queries::FindRestQuery.call(
        params[:preferred_brands],
        params[:brands],
        params[:user],
        params[:price_range],
        params[:limit],
        params[:offset]
      )
    end

    def find_rest_count_all(**)
      # We don't need to know this amount, because rest - is last part
      # of results
      0
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
        # We can get brands ids now to prevent subqueries from executing further
        brands: brand_query.present? ? Queries::BrandsBySubStringQuery.call(brand_query) : [],
        preferred_brands: user.preferred_brands,
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
