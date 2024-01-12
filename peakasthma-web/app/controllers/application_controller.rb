class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  respond_to :html
  self.responder = Metova::Responder

  def self.authenticated!(options = {})
    before_action :authenticate_user!, options
  end

  def redirect_non_admin
    redirect_to root_path unless current_user&.admin?
  end

  def redirect_wrong_patient
    redirect_to root_path unless current_user&.admin? || (params[:patient_id] && current_user.patient.id.to_s == params[:patient_id])
  end
end
