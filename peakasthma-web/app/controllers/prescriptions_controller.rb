class PrescriptionsController < ApplicationController
  authenticated!
  before_action :redirect_non_admin
  before_action :find_patient
  before_action :find_prescription, only: [:edit, :update, :destroy]

  # helper_method :valid_frequencies
  # helper_method :valid_units

  def new
    @prescription = Prescription.new
  end

  def create
    begin
      @prescription = Prescription.new

      Prescription.transaction do
        if create_params[:unit_id] == nil
          if FormulationType.find(create_params[:formulation_id]).kind == FormulationType::FORMULATIONS[:inhaled_puffs]
            @prescription = @patient.prescriptions.create(create_params.to_hash.merge({ prescriber_id: current_user.id, unit_id: UnitType.find_by(kind: UnitType::UNITS[FormulationType::FORMULATIONS[:inhaled_puffs]][:puffs]).id }).except('level_ids'))
          elsif FormulationType.find(create_params[:formulation_id]).kind == FormulationType::FORMULATIONS[:inhaled_vials]
            @prescription = @patient.prescriptions.create(create_params.to_hash.merge({ prescriber_id: current_user.id, unit_id: UnitType.find_by(kind: UnitType::UNITS[FormulationType::FORMULATIONS[:inhaled_vials]][:vials]).id }).except('level_ids'))
          else
            @prescription = @patient.prescriptions.create(create_params.to_hash.merge({ prescriber_id: current_user.id, unit_id: UnitType.find_by(kind: UnitType::UNITS[FormulationType::FORMULATIONS[:injection]][:injection]).id }).except('level_ids'))
          end
        else
          @prescription = @patient.prescriptions.create(create_params.to_hash.merge(prescriber_id: current_user.id).except('level_ids'))
        end
        
        validate_params(create_params)
        
        create_prescription_levels(create_params)
      end
    rescue ActiveRecord::RecordInvalid
      puts 'Prescription levels cannot be empty.'
    rescue ActionController::ParameterMissing => exception
      puts exception
    end

    respond_with @prescription, location: patient_path(@patient)
  end

  def update
    if (!@prescription.confirm_status) and (update_params[:confirm_status] == 'true')
      # Update confirm status
      begin
        Prescription.transaction do
          @prescription.update(update_params)
        end
      end
    else
      # Invalidate a prescription and create a new prescription
      begin
        # Invalidate this prescription
        @prescription.update({:valid_status => false, :invalid_reason => "Update", :invalid_at => Time.now.getutc})

        # Create a new prescription
        Prescription.transaction do
          if update_params[:unit_id] == nil
            if FormulationType.find(update_params[:formulation_id]).kind == FormulationType::FORMULATIONS[:inhaled_puffs]
              @prescription = @patient.prescriptions.create(update_params.to_hash.merge({ prescriber_id: current_user.id, unit_id: UnitType.find_by(kind: UnitType::UNITS[FormulationType::FORMULATIONS[:inhaled_puffs]][:puffs]).id }).except('level_ids'))
            elsif FormulationType.find(update_params[:formulation_id]).kind == FormulationType::FORMULATIONS[:inhaled_vials]
              @prescription = @patient.prescriptions.create(update_params.to_hash.merge({ prescriber_id: current_user.id, unit_id: UnitType.find_by(kind: UnitType::UNITS[FormulationType::FORMULATIONS[:inhaled_vials]][:vials]).id }).except('level_ids'))
            else
              @prescription = @patient.prescriptions.create(update_params.to_hash.merge({ prescriber_id: current_user.id, unit_id: UnitType.find_by(kind: UnitType::UNITS[FormulationType::FORMULATIONS[:injection]][:injection]).id }).except('level_ids'))
            end


          else
            @prescription = @patient.prescriptions.create(update_params.to_hash.merge(prescriber_id: current_user.id).except('level_ids'))
          end
          
          validate_params(update_params)
          
          create_prescription_levels(update_params)
        end
      rescue ActiveRecord::RecordInvalid
        puts 'Prescription levels cannot be empty.'
      rescue ActionController::ParameterMissing => exception
        puts exception
      end
    end
    

    respond_with @prescription, location: patient_path(@patient)
  end

  def destroy
    @prescription.update({:valid_status => false, :invalid_reason => "Delete", :invalid_at => Time.now.getutc})
    respond_with @prescription, location: patient_path(@patient)
  end

  def edit
  end

  def fields
    puts selected_formulation
    render 'prescriptions/_fields', locals: { formulation: FormulationType.find(selected_formulation) }, layout: false
  end

  private
    def create_params
      params.require(:prescription).permit(:quantity, :unit_id, :formulation_id, :frequency_id, :medication_id, :reminder_day, :level_ids => [])
    end

    def update_params
      params.require(:prescription).permit(:quantity, :unit_id, :formulation_id, :frequency_id, :medication_id, :reminder_day, :valid_status, :invalid_reason, :invalid_at, :confirm_status, :confirm_at, :level_ids => [])
    end

    def find_patient
      @patient = Patient.find(params[:patient_id])
    end

    def find_prescription
      @prescription = Prescription.find(params[:id])
    end

    def selected_formulation
      params.require(:dynamic_view).require(:id)
    end

    def validate_params(param)
      param.each do |key, p|
        if p == ""
          if key == 'reminder_day'
            if create_params[:level_ids] && create_params[:level_ids].include?('1')
              @prescription.errors.add(key, t("prescription.model.reminder_day") + ' field is required for ' + t("prescription.model.levels.green") + '.')
              flash[:alert] = t("prescription.model.reminder_day") + ' field is required for ' + t("prescription.model.levels.green") + '.'
              raise ActionController::ParameterMissing.new(key)
            end
          else
            @prescription.errors.add(key, t("prescription.model.#{key.chomp('_id')}") + ' field is required.')
            flash[:alert] = t("prescription.model.#{key.chomp('_id')}") + ' field is required.'
            raise ActionController::ParameterMissing.new(key)
          end
        end
      end
    end

    def create_prescription_levels(param)
      if param[:level_ids] != nil
        param[:level_ids].each do |level|
          level = @prescription.prescription_levels.create(level_id: level)
          if level.errors.size != 0
            @prescription.errors.add(:level, 'Cannot create prescription level.')
            puts 'Cannot create prescription level.'
            puts level.errors.full_messages
            raise ActiveRecord::RecordInvalid
          end
        end
      else
        @prescription.errors.add(:level, 'Prescription levels cannot be empty.')
        flash[:alert] = 'Must select at least one prescription level.'
        raise ActiveRecord::RecordInvalid
      end
    end
end
