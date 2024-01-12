json.prescription do
  json.partial! 'api/prescriptions/prescription', prescription: taken_prescription_record.prescription
end
json.created taken_prescription_record.created_at
