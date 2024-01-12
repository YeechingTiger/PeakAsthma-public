class ControlPatientVisitJob < ApplicationJob
    # This job will run one time everyday, and update the patient visit information

    def perform
        patients = ControlPatient.all
        # Check the patient visit related survey and create or update new row
        for p in patients
            patient_visits_record = ControlPatientVisitsRecord.where("control_patient_id = ?", p.id).first

            if patient_visits_record == nil
              patient_visits_record = ControlPatientVisitsRecord.new
              patient_visits_record.control_patient_id = p.id
              
              scheduled_visit_dates = RedcapAPI.get_scheduled_visit_dates(p[:redcap_id])
              three_month_inpatient_visit_survey = RedcapAPI.get_inpatient_visit(p[:redcap_id], 3)
              twelve_month_inpatient_visit_survey = RedcapAPI.get_inpatient_visit(p[:redcap_id], 12)

              patient_visits_record.three_month_scheduled_visit_date = scheduled_visit_dates['3_month_schedule_visit_date']
              patient_visits_record.twelve_month_scheduled_visit_date = scheduled_visit_dates['12_month_schedule_visit_date']

              patient_visits_record.three_month_survey_status = three_month_inpatient_visit_survey
              patient_visits_record.twelve_month_survey_status = twelve_month_inpatient_visit_survey

              puts patient_visits_record
              patient_visits_record.save
            else
              if patient_visits_record.three_month_survey_status == false
                three_month_inpatient_visit_survey = RedcapAPI.get_inpatient_visit(p[:redcap_id], 3)
                patient_visits_record.update(three_month_survey_status: three_month_inpatient_visit_survey)
              end

              if patient_visits_record.twelve_month_survey_status == false
                twelve_month_inpatient_visit_survey = RedcapAPI.get_inpatient_visit(p[:redcap_id], 12)
                patient_visits_record.update(twelve_month_survey_status: twelve_month_inpatient_visit_survey)
              end

              scheduled_visit_dates = RedcapAPI.get_scheduled_visit_dates(p[:redcap_id])
              patient_visits_record.update(three_month_scheduled_visit_date: scheduled_visit_dates['3_month_schedule_visit_date'],
                                          twelve_month_scheduled_visit_date: scheduled_visit_dates['12_month_schedule_visit_date'])
            
            end
            
          
        end
      end
  end