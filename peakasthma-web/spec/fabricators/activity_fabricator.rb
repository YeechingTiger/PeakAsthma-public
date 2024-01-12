Fabricator(:activity) do
  patient
  subject { Fabricate :peak_flow, patient: patient }
end
