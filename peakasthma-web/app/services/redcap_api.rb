class RedcapAPI
  require 'net/http'
  require 'json'

  REDCAP_URL = URI.parse('https://base.uams.edu/redcap/api/')
  TOKEN = ''

  def self.get_patient_monthly_survey(redcap_id, month)
    field = (month == 6 || month == 9) ? 'mhealth_mobile_survey_6_and_9_mos_complete' : 'mhealth_mobile_survey_complete'
    form = (month == 6 || month == 9) ? 'mhealth_mobile_survey_6_and_9_mos' : 'mhealth_mobile_survey'

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: field,
      forms: form,
      events: "#{month}_mo_arm_1",
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)
    puts data
    complete = !data.empty? && data[0][field] != '0'

    (res.code == '200' && complete) ? data : nil
  end

  def self.get_inpatient_visit(redcap_id, month)
    field = month == 3 ? 'three_months_inperson_visit_complete' : 'twelve_months_inperson_visit_complete'
    form = month == 3 ? 'three_months_inperson_visit' : 'twelve_months_inperson_visit'

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: field,
      forms: form,
      events: "#{month}_mo_arm_1",
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)
    complete = !data.empty? && data[0][field] != '0'
    complete
  end

  def self.get_scheduled_visit_dates(redcap_id)
    field_3_month = 'rm_m3_sch_date'
    field_12_month = 'rm_m12_sch_date'
    form = 'radar_management'

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      forms: form,
      events: "management_arm_1",
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)
    response = {}
    if !data.empty?
      response['3_month_schedule_visit_date'] = data[0][field_3_month]
      response['12_month_schedule_visit_date'] = data[0][field_12_month]
    end
    response
  end



  def self.get_patient_group_id(redcap_id, month)
    field = 'group'
    form = 'mhealth_mobile_survey'

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: field,
      forms: form,
      events: "baseline_arm_1",
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)
    if data and data[0]
      group_id = data[0]['group']
    end
    group_id
  end
  

  def self.get_all_patients_consent_date
    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      fields: 'id_num,rm_consent_date',
      events: 'management_arm_1',
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)

    (res.code == '200') ? data : []
  end

  def self.get_patient_consent_date(redcap_id)
    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: 'rm_consent_date',
      events: 'management_arm_1',
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)

    if res.code == '200' && !data.empty? && data[0]['rm_consent_date'] != ''
      Date.parse(data[0]['rm_consent_date'])
    else
      Date.parse('2100-01-01')
    end
  end

  def self.get_survey_link(redcap_id, month)
    instrument = (month == 6 || month == 9) ? 'mhealth_mobile_survey_6_and_9_mos' : 'mhealth_mobile_survey'

    query_params = {
      token: TOKEN,
      content: 'surveyLink',
      format: 'json',
      instrument: instrument,
      event: "#{month}_mo_arm_1",
      record: redcap_id,
      returnFormat: 'json'
    }

    res = send_request(query_params)

    (res.code == '200') ? res.body : nil
  end

  def self.get_patient_demographic_info(redcap_id)
    if redcap_id == nil || redcap_id == ''
      return {}
    end

    info = {}

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: 'e_child_name,e_dob,e_gender',
      events: 'management_arm_1',
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)

    if res.code == '200' && !data.empty?
      if data[0]['e_child_name'] != nil
        words = data[0]['e_child_name'].strip.split(' ')
        info[:first_name] = words.length > 0 ? words[0] : nil
        info[:last_name] = words.length > 0 ? words[-1] : nil
      else
        info[:first_name] = nil
        info[:last_name] = nil
      end
      info[:dob] = data[0]['e_dob']
      info[:gender] = data[0]['e_gender'] != nil ? data[0]['e_gender'].to_i - 1 : nil
    end

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: 'b_pcp_name,b_spir_height,b_spir_weight',
      events: 'baseline_arm_1',
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)

    if res.code == '200' && !data.empty?
      info[:pcp] = data[0]['b_pcp_name']
      info[:height] = data[0]['b_spir_height'] != nil ? Integer(data[0]['b_spir_height'].to_f / 2.54) : nil
      info[:weight] = data[0]['b_spir_weight'] != nil ? (data[0]['b_spir_weight'].to_f / 0.4536).round(1) : nil
    end

    info
  end

  def self.get_patient_caregiver_info(redcap_id)
    if redcap_id == nil || redcap_id == ''
      return {}
    end

    info = {}

    query_params = {
      token: TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      records: redcap_id,
      fields: 'b_caregiver_name,b_caregiver_rel,b_caregiver_email,b_caregiver_cell_phone',
      events: 'baseline_arm_1',
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }

    res = send_request(query_params)
    data = JSON.parse(res.body)

    if res.code == '200' && !data.empty?
      if data[0]['b_caregiver_name'] != nil
        words = data[0]['b_caregiver_name'].strip.split(' ')
        info[:first_name] = words.length > 0 ? words[0] : nil
        info[:last_name] = words.length > 0 ? words[-1] : nil
      else
        info[:first_name] = nil
        info[:last_name] = nil
      end
      if data[0]['b_caregiver_cell_phone'] != nil
        info[:cell] = data[0]['b_caregiver_cell_phone'].gsub(/[^0-9]/, '').insert(6, '-').insert(3, '-')
      else
        info[:cell] = nil
      end
      info[:email] = data[0]['b_caregiver_email']
      info[:relation] = data[0]['b_caregiver_rel'] != nil ? data[0]['b_caregiver_rel'].to_i - 1 : nil
    end

    info
  end

  private_class_method

  def self.send_request(query_params)
    http = Net::HTTP.new(REDCAP_URL.host, REDCAP_URL.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(REDCAP_URL.to_s)
    req['Content-Type'] = 'application/json'
    req.set_form_data(query_params)

    http.request(req)
  end

end
