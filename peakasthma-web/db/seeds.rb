require 'csv'

med_types_csv_text = File.read(Rails.root.join('lib', 'seeds', 'med_types.csv'))
med_types_csv_output = CSV.parse(med_types_csv_text, headers: true, encoding: 'ISO-8859-1')
med_types_csv_output.uniq.each do |row|
med_type = MedicationType.new
med_type.kind = row['Type']
if MedicationType::ALL_TYPES.include?(med_type.kind)
  MedicationType.find_or_create_by!(kind: med_type.kind)
else
  puts 'Invalid medication type.'
end
end

level_types_csv_text = File.read(Rails.root.join('lib', 'seeds', 'levels.csv'))
level_types_csv_output = CSV.parse(level_types_csv_text, headers: true, encoding: 'ISO-8859-1')
level_types_csv_output.uniq.each do |row|
  level_type = LevelType.new
  level_type.kind = row['Level']
  if LevelType::ALL_LEVELS.include?(level_type.kind)
    LevelType.find_or_create_by!(kind: level_type.kind)
  else
    puts 'Invalid level type.'
  end
end

formulation_types_csv_text = File.read(Rails.root.join('lib', 'seeds', 'formulations.csv'))
formulation_types_csv_output = CSV.parse(formulation_types_csv_text, headers: true, encoding: 'ISO-8859-1')
formulation_types_csv_output.uniq.each do |row|
  formulation_type = FormulationType.new
  formulation_type.kind = row['Formulation']
  if FormulationType::ALL_FORMULATIONS.include?(formulation_type.kind)
    FormulationType.find_or_create_by!(kind: formulation_type.kind)
  else
    puts 'Invalid formulation type.'
  end
end

frequency_types_csv_text = File.read(Rails.root.join('lib', 'seeds', 'frequencies.csv'))
frequency_types_csv_output = CSV.parse(frequency_types_csv_text, headers: true, encoding: 'ISO-8859-1')
frequency_types_csv_output.uniq.each do |row|
  frequency_type = FrequencyType.new
  frequency_type.kind = row['Frequency']
  if FrequencyType::ALL_FREQUENCIES.include?(frequency_type.kind)
    FrequencyType.find_or_create_by!(kind: frequency_type.kind)
  else
    puts 'Invalid frequency type.'
  end
end

unit_types_csv_text = File.read(Rails.root.join('lib', 'seeds', 'units.csv'))
unit_types_csv_output = CSV.parse(unit_types_csv_text, headers: true, encoding: 'ISO-8859-1')
unit_types_csv_output.uniq.each do |row|
  unit_type = UnitType.new
  unit_type.kind = row['Unit']
  if UnitType::ALL_UNITS.include?(unit_type.kind)
    UnitType.find_or_create_by!(kind: unit_type.kind)
  else
    puts 'Invalid unit type.'
  end
end

medications_csv_text = File.read(Rails.root.join('lib', 'seeds', 'medications.csv'))
medications_csv_output = CSV.parse(medications_csv_text, headers: true, encoding: 'utf-8')
medications_csv_output.uniq.each do |row|
  puts row
  medication = Medication.new
  medication.name = row['Name']
  med_type = row['Type']
  if MedicationType::ALL_TYPES.include?(med_type)
    medication.type_id = MedicationType.find_by(kind: med_type).id
  else
    medication.type_id = MedicationType.find_by(kind: 'Other').id
  end
  Medication.find_or_create_by!(name: medication.name, type_id: medication.type_id)
end

symptoms_csv_text = File.read(Rails.root.join('lib', 'seeds', 'symptoms.csv'))
symptoms_csv_output = CSV.parse(symptoms_csv_text, headers: true, encoding: 'ISO-8859-1')
symptoms_csv_output.uniq { |row| row['Symptom Name'] }.each do |row|
  symptom = Symptom.new
  symptom.name = row['Symptom Name']
  symptom.category = row['Category']
  symptom.emergency = row['Emergency']
  level = row['Level']
  level = level.downcase.to_sym unless level.nil?
  if level && PeakFlow::LEVELS.include?(level)
    symptom.level = level
  else
    symptom.level = :yellow
  end

  Symptom.find_or_create_by!(name: symptom.name, level: symptom.level, category: symptom.category, emergency: symptom.emergency)
end

tips_csv_text = File.read(Rails.root.join('lib', 'seeds', 'tips.csv'))
tips_csv_output = CSV.parse(tips_csv_text, headers: true, encoding: 'ISO-8859-1')
tips_csv_output.uniq { |row| row['Tip'] }.each do |row|
  tip_new = Tip.new
  tip_new.tip = row['Tip']
  tip_new.schedule = row['Schedule']
#   puts tip_new
  Tip.find_or_create_by!(tip: tip_new.tip, schedule: tip_new.schedule)
end

videos_csv_text = File.read(Rails.root.join('lib', 'seeds', 'videos.csv'))
puts videos_csv_text
videos_csv_output = CSV.parse(videos_csv_text, headers: true, encoding: 'ISO-8859-1')
videos_csv_output.uniq.each do |row|
  video_new = Video.new
  video_new.video_name = row[0].to_str
  video_new.url = row['url']
  video_new.week = row['week']
  video_new.day = row['day']
#   puts tip_new
  Video.find_or_create_by!(video_name: video_new.video_name, url: video_new.url, week: video_new.week, day: video_new.day)
end


#admin = User.create_with(password: 'password1').find_or_create_by!(username: 'admin', email: 'admin@peak-asthma.com', first_name: 'Admin', last_name: 'Admin', role: :admin)
admin = User.create_with(password: 'password1').find_or_create_by!(username: 'admin', email: 'hexingdashen@gmail.com', first_name: 'Admin', last_name: 'Admin', role: :admin)
admin.confirm
