class PeakFlowsController < ApplicationController
  authenticated!
  before_action :redirect_wrong_patient
  before_action :find_patient

  def index
    
  end

  private
    def find_patient
      @patient = Patient.find(params[:patient_id])
    end
end
