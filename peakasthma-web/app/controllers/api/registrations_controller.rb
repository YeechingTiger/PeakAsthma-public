module API
  class RegistrationsController < ::Devise::RegistrationsController
    include Metova::Devise::Controller

    before_action :configure_permitted_parameters, if: :devise_controller?

    rescue_from(ActionController::ParameterMissing) do |_parameter_missing_exception|
      render json: { message: I18n.t('missing_params') }, status: :unprocessable_entity
    end

    protected
      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :first_name, :last_name, patient_attributes: [:birthday, :gender]] )
        devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :first_name, :last_name] )
      end
  end
end
