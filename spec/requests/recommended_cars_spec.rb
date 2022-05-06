# frozen_string_literal: true

describe 'Recommended cars', type: :request do
  describe 'GET /recommended_cars' do
    include_context 'stub external ai'

    it 'returns status code 200' do
      get '/api/v1/recommended_cars?user_id=1'
      expect(response).to have_http_status(:success)
    end

    it 'returns error for invalid user_id', :aggregate_failures do
      get '/api/v1/recommended_cars?user_id=2'
      expect(response).to have_http_status(:bad_request)
      expect(json).to eq('error' => 'User not found')
    end

    it 'returns error2 for invalid user_id', :aggregate_failures do
      get '/api/v1/recommended_cars'
      expect(response).to have_http_status(:bad_request)
      expect(json).to eq('error' => 'Required parameter missing: user_id')
    end

    it 'returns error for invalid price params' do
      get '/api/v1/recommended_cars?user_id=1&price_min=KU'
      expect(json).to eq({ 'error' => { 'price_min' => ['is not a number'] } })
    end
  end
end
