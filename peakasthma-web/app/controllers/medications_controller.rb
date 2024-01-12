class MedicationsController < ApplicationController
  authenticated!
  
  before_action :redirect_non_admin
  before_action :find_medication, only: [:show, :update, :destroy]

  def index
    if params[:search] && params[:search][:name] != ""
      @medications = Medication.where('lower(name) LIKE ?', "%#{search_params[:name].downcase}%").order(updated_at: :desc).paginate(page: params[:page])
    else
      @medications = Medication.all.order(:name).paginate(page: params[:page])
    end
  end

  def create
    @medication = Medication.create(medication_params)
    respond_with @medication, location: medications_path
  end

  def update
    @medication.update(medication_params)
    respond_with @medication, location: medications_path
  end

  def destroy
    @medication.destroy
    ClearMedReminderJob.perform_later
    respond_with @medication, location: medications_path
  end

  def edit
  end

  private
    def find_medication
      @medication = Medication.find(params[:id])
    end

    def medication_params
      params.require(:medication).permit(:name, :type_id)
    end

    def search_params
      params.require(:search).permit(:name)
    end
end
