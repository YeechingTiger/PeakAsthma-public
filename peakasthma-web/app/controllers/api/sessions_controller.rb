module API
  class SessionsController < ::Devise::SessionsController 
		include Metova::Devise::Controller
    skip_before_action :verify_signed_out_user, only: [:destroy, :destroy_session]
    after_action :record_log_in, only: [:create]
    
    def destroy_session
      respond_to do |format|
      	format.json {}
        format.html { super }
      end
    end

private
    def record_log_in
      if current_user&.first_mobile_login? && current_user&.accept_policy?
        current_user.update(used_mobile_app: true)
      end
    end

    def respond_to_on_destroy
      respond_to do |format|
        format.all { head :no_content }
        format.any(*navigational_formats) {
          session.destroy
          render plain: "Sign Out"
        }
      end
    end
  end
end
