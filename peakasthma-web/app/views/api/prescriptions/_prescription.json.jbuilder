if prescription.present?
  json.id prescription.id
  json.formulation FormulationType::FORMULATIONS.key(FormulationType.find(prescription.formulation_id).kind)
  json.frequency FrequencyType::FREQUENCIES.values.reduce({}, :merge).key(FrequencyType.find(prescription.frequency_id).kind)
  json.dosage prescription.dosage
  json.levels prescription.level_names
  json.medication do
    json.partial! 'api/prescriptions/medication', medication: prescription.medication
  end
end
