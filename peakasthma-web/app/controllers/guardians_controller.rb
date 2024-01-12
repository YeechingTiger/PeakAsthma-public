class GuardiansController < ApplicationController
  authenticated!
  # before_action :redirect_non_admin
  before_action :find_patient
  before_action :find_guardian, only: [:edit, :update, :destroy]


  def new
    @guardian = Guardian.new
    @guardian.user = User.new
    fill_redcap_data(@guardian, params['import-redcap-id'])
  end

  def create
    @guardian = @patient.guardians.create(create_params)
    respond_with @guardian, location: patient_path(@patient)
  end

  def update
    @guardian.update(update_params)
    respond_with @guardian, location: patient_path(@patient)
  end

  def destroy
    @guardian.user.destroy
    @guardian.destroy
    redirect_to patient_path(@patient)
  end

  def edit
    fill_redcap_data(@guardian, params['import-redcap-id'])
  end

  private
    def create_params
      valid_params = params.require(:guardian).permit(
        :relationship_to_patient, 
        :phone, 
        :notification_type,
        # user_attributes: [:id, :first_name, :last_name, :username, :email, :password, :role])
        user_attributes: [:id, :first_name, :last_name, :username, :email, :role])
        valid_params[:user_attributes][:encrypted_password] = '$2a$11$cixW0odcieVc4XgCQ.mu.evLbsvuR/6aqANX/8Sup8EXPU/gkDNP6'
        valid_params
    end

    def update_params
      params.require(:guardian).permit(
        :relationship_to_patient, 
        :phone,
        :notification_type,
        user_attributes: [:id, :first_name, :last_name, :username, :email, :password, :role])
    end

    def find_patient
      @patient = Patient.find(params[:patient_id])
    end

    def find_guardian
      @guardian = Guardian.find(params[:id])
    end

    def fill_redcap_data(guardian, redcap_id)
      info = RedcapAPI.get_patient_caregiver_info(redcap_id)

      guardian.relationship_to_patient = info[:relation] if info[:relation] != nil
      guardian.phone = info[:cell] if info[:cell] != nil

      guardian.user.first_name = info[:first_name] if info[:first_name] != nil
      guardian.user.last_name = info[:last_name] if info[:last_name] != nil
      guardian.user.email = info[:email] if info[:email] != nil
    end
end
