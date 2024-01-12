class SymptomsController < ApplicationController
  authenticated!
  
  before_action :redirect_non_admin
  before_action :find_symptom, only: [:edit, :update, :destroy]

  def index
    @symptoms = Symptom.all.order([:level, :name]).paginate(page: params[:page])
  end

  def create
    @symptom = Symptom.create(symptom_params)
    respond_with @symptom, location: symptoms_path
  end

  def update
    @symptom.update(symptom_params)
    respond_with @symptom, location: symptoms_path
  end

  def destroy
    @symptom.destroy
    respond_with @symptom, location: symptoms_path
  end

  def edit
  end

  def new
    @symptom = Symptom.new
  end

  private
    def find_symptom
      @symptom = Symptom.find(params[:id])
    end

    def symptom_params
      params.require(:symptom).permit(:name, :level, :category, :emergency)
    end
end
