# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    render json: { error:
                     I18n.t('recommendations.bad_params', name: parameter_missing_exception.param) },
           status: :bad_request
  end
end
