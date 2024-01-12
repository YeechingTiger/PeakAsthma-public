json.peak_flow do
  json.partial! 'api/peak_flows/peak_flow', peak_flow: @peak_flow
end

unless @prescription.nil?
  json.prescription do
    json.partial! 'api/prescriptions/prescription', prescription: @prescription
  end
end
