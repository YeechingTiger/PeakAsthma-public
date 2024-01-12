json.activities @control_activities do |activity|
   json.id 'act_' + activity.id.to_s  
   json.set! activity.subject_type.underscore do
    if activity.subject.present?
      json.partial! activity.subject
    end
  end
end
