class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token]) if params[:confirmation_token].present?
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    self.resource = resource_class.find_by_confirmation_token(confirmation_params[:confirmation_token]) if confirmation_params[:confirmation_token].present?
    if resource.update_attributes(confirmation_params) && resource.password_match?
      self.resource = resource_class.confirm_by_token(confirmation_params[:confirmation_token])
      sign_in_and_redirect(resource_name, resource)
    else
      render :action => "show"
    end
  end

  private
    def confirmation_params
      params.require(resource_name).permit(:password, :password_confirmation, :confirmation_token)
    end
end