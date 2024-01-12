json.prescriptions current_user.patient.prescriptions.where(valid_status: true) do |prescription|
  json.partial! 'api/prescriptions/prescription', prescription: prescription
end
