json.id peak_flow.id
json.score peak_flow.score
json.symptoms peak_flow.symptoms do |symptom|
  json.partial! 'api/symptoms/symptom', symptom: symptom
end
json.level peak_flow.level
json.created peak_flow.created_at
json.updated peak_flow.updated_at
json.feeling peak_flow.feeling
