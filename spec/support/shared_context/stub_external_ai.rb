# frozen_string_literal: true

shared_context 'stub external ai' do
  before do
    stub_request(:get, "#{ENV.fetch('EXT_AI_SERVICE')}?user_id=1")
      .to_return(status: 200, body: json_fixture('external_ai.json').to_json, headers: {})
  end
end
