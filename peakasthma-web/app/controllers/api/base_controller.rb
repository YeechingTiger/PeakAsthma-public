module API
  class BaseController < ::ApplicationController
    respond_to :json
    skip_before_action :verify_authenticity_token    
    # protect_from_forgery with: :null_session
    rescue_from(ActionController::ParameterMissing) do |_parameter_missing_exception|
      render json: { message: I18n.t('missing_params') }, status: :unprocessable_entity
    end

    before_action :register_device

    self.responder = Metova::Responder

    def register_device
      return unless current_user
      device_token_header = request.headers['X-PeakAsthma-Device-Token']
      current_user.patient.update(device_token: device_token_header) if device_token_header
    end
  end
end
