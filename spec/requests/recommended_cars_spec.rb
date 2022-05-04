# frozen_string_literal: true

describe 'Recommended cars', type: :request do
  describe 'GET /recommended_cars' do
    include_context 'stub external ai'

    it 'returns status code 200', :aggregate_failures do
      get '/api/v1/recommended_cars?user_id=1'

      expect(response).to have_http_status(:success)
    end

    pending 'returns error for invalid user_id'
    pending 'returns error for invalid price params'
  end
end
