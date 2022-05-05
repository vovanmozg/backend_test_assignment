# frozen_string_literal: true

# Helpers for requests specs
module ApiHelpers
  def json
    JSON.parse(response.body)
  end
end
