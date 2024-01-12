# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_15_154810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_activities_on_patient_id"
    t.index ["subject_type", "subject_id"], name: "index_activities_on_subject_type_and_subject_id"
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.text "to"
    t.string "mailer"
    t.text "subject"
    t.datetime "sent_at"
    t.string "token"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.integer "exacerbation_id"
    t.index ["token"], name: "index_ahoy_messages_on_token"
    t.index ["user_type", "user_id"], name: "index_ahoy_messages_on_user_type_and_user_id"
  end

  create_table "alert_tables", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "alert"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_alert_tables_on_patient_id"
  end

  create_table "clincard_balance_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clincard_balance_requests_on_user_id"
  end

  create_table "control_activities", force: :cascade do |t|
    t.bigint "control_patient_id", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_patient_id"], name: "index_control_activities_on_control_patient_id"
    t.index ["subject_type", "subject_id"], name: "index_control_activities_on_subject_type_and_subject_id"
  end

  create_table "control_incentive_records", force: :cascade do |t|
    t.bigint "control_patient_id"
    t.integer "day"
    t.integer "week"
    t.integer "month"
    t.boolean "get_incentive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_patient_id"], name: "index_control_incentive_records_on_control_patient_id"
  end

  create_table "control_notifications", force: :cascade do |t|
    t.string "message", null: false
    t.datetime "send_at", null: false
    t.boolean "sent", default: false, null: false
    t.bigint "user_id"
    t.integer "alert", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_patient"
    t.index ["user_id"], name: "index_control_notifications_on_user_id"
  end

  create_table "control_notifications_control_patients", id: false, force: :cascade do |t|
    t.bigint "control_patient_id", null: false
    t.bigint "control_notification_id", null: false
    t.index ["control_notification_id"], name: "index_control_notifications_control_patients"
  end

  create_table "control_patient_reward_records", force: :cascade do |t|
    t.bigint "control_patient_id"
    t.datetime "logging_over_day"
    t.float "payment_amount"
    t.integer "month"
    t.boolean "get_paid", default: false
    t.boolean "survey_complete"
    t.datetime "survey_complete_day"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_patient_id"], name: "index_control_patient_reward_records_on_control_patient_id"
  end

  create_table "control_patient_visits_records", force: :cascade do |t|
    t.datetime "three_month_scheduled_visit_date"
    t.boolean "three_month_survey_status"
    t.boolean "three_month_payment_status", default: false
    t.string "three_month_visit_note"
    t.string "three_month_comment"
    t.datetime "twelve_month_scheduled_visit_date"
    t.boolean "twelve_month_survey_status"
    t.boolean "twelve_month_payment_status", default: false
    t.string "twelve_month_visit_note"
    t.string "twelve_month_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "control_patient_id"
    t.index ["control_patient_id"], name: "index_control_patient_visits_records_on_control_patient_id"
  end

  create_table "control_patients", force: :cascade do |t|
    t.date "birthday"
    t.integer "gender", default: 0, null: false
    t.integer "height"
    t.float "weight"
    t.bigint "user_id", null: false
    t.string "phone"
    t.string "physician"
    t.integer "race"
    t.string "device_token"
    t.boolean "daily_reminders", default: false
    t.datetime "daily_reminder_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "redcap_id", null: false
    t.index ["redcap_id"], name: "index_control_patients_on_redcap_id", unique: true
    t.index ["user_id"], name: "index_control_patients_on_user_id"
  end

  create_table "diet_records", force: :cascade do |t|
    t.bigint "control_patient_id", null: false
    t.float "fruit", default: 0.0, null: false
    t.float "vegetable", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "record_date", null: false
    t.index ["control_patient_id"], name: "index_diet_records_on_control_patient_id"
  end

  create_table "exacerbations", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "exacerbation"
    t.string "comment"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formulation_types", force: :cascade do |t|
    t.string "kind", null: false
  end

  create_table "frequency_types", force: :cascade do |t|
    t.string "kind", null: false
  end

  create_table "guardians", force: :cascade do |t|
    t.integer "relationship_to_patient", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id"
    t.string "phone"
    t.bigint "user_id"
    t.integer "notification_type", default: 0
    t.index ["patient_id"], name: "index_guardians_on_patient_id"
    t.index ["user_id"], name: "index_guardians_on_user_id"
  end

  create_table "incentive_records", force: :cascade do |t|
    t.bigint "patient_id"
    t.integer "day"
    t.integer "week"
    t.integer "month"
    t.boolean "get_incentive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_incentive_records_on_patient_id"
  end

  create_table "level_types", force: :cascade do |t|
    t.string "kind", null: false
  end

  create_table "medication_types", force: :cascade do |t|
    t.string "kind", null: false
  end

  create_table "medications", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "type_id", null: false
    t.index ["name"], name: "index_medications_on_name", unique: true
    t.index ["type_id"], name: "index_medications_on_type_id"
  end

  create_table "medications_symptoms", id: false, force: :cascade do |t|
    t.bigint "medication_id"
    t.bigint "symptom_id"
    t.index ["medication_id"], name: "index_medications_symptoms_on_medication_id"
    t.index ["symptom_id"], name: "index_medications_symptoms_on_symptom_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "message", null: false
    t.datetime "send_at", null: false
    t.boolean "sent", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "alert", default: 0, null: false
    t.boolean "tip_flag", default: false
    t.integer "target_patient"
    t.index ["alert"], name: "index_notifications_on_alert"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "notifications_patients", id: false, force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "notification_id"
    t.index ["notification_id"], name: "index_notifications_patients_on_notification_id"
    t.index ["patient_id"], name: "index_notifications_patients_on_patient_id"
  end

  create_table "patient_reward_records", force: :cascade do |t|
    t.bigint "patient_id"
    t.datetime "logging_over_day"
    t.float "payment_amount"
    t.integer "month"
    t.boolean "get_paid", default: false
    t.boolean "survey_complete"
    t.datetime "survey_complete_day"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group_id"
    t.index ["patient_id"], name: "index_patient_reward_records_on_patient_id"
  end

  create_table "patient_visits_records", force: :cascade do |t|
    t.bigint "patient_id"
    t.datetime "three_month_scheduled_visit_date"
    t.boolean "three_month_payment_status", default: false
    t.string "three_month_comment"
    t.datetime "twelve_month_scheduled_visit_date"
    t.boolean "twelve_month_payment_status", default: false
    t.string "twelve_month_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "three_month_survey_status", default: false
    t.boolean "twelve_month_survey_status", default: false
    t.string "three_month_visit_note"
    t.string "twelve_month_visit_note"
    t.index ["patient_id"], name: "index_patient_visits_records_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.date "birthday"
    t.integer "height"
    t.float "weight"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "physician"
    t.integer "yellow_zone_minimum", default: 170
    t.integer "yellow_zone_maximum", default: 220
    t.integer "race"
    t.integer "zip_code"
    t.integer "gender", default: 0, null: false
    t.string "device_token"
    t.boolean "medication_reminders", default: false
    t.datetime "medication_reminder_time"
    t.integer "remind_later_time"
    t.datetime "report_reminder_time"
    t.string "redcap_id", null: false
    t.index ["redcap_id"], name: "index_patients_on_redcap_id", unique: true
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "patients_videos", id: false, force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_patients_videos_on_patient_id"
    t.index ["video_id"], name: "index_patients_videos_on_video_id"
  end

  create_table "peak_flows", force: :cascade do |t|
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id"
    t.string "feeling"
    t.index ["patient_id"], name: "index_peak_flows_on_patient_id"
  end

  create_table "peak_flows_symptoms", id: false, force: :cascade do |t|
    t.bigint "symptom_id"
    t.bigint "peak_flow_id"
    t.index ["peak_flow_id"], name: "index_peak_flows_symptoms_on_peak_flow_id"
    t.index ["symptom_id"], name: "index_peak_flows_symptoms_on_symptom_id"
  end

  create_table "prescription_levels", force: :cascade do |t|
    t.bigint "prescription_id", null: false
    t.bigint "level_id", null: false
    t.index ["level_id"], name: "index_prescription_levels_on_level_id"
    t.index ["prescription_id"], name: "index_prescription_levels_on_prescription_id"
  end

  create_table "prescription_refill_records", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "prescription_id"
    t.date "refill_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_prescription_refill_records_on_patient_id"
    t.index ["prescription_id"], name: "index_prescription_refill_records_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "medication_id", null: false
    t.bigint "prescriber_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "patient_id", null: false
    t.integer "quantity", null: false
    t.bigint "formulation_id", null: false
    t.bigint "frequency_id", null: false
    t.bigint "unit_id", null: false
    t.integer "reminder_day"
    t.boolean "valid_status", default: true
    t.string "invalid_reason"
    t.datetime "invalid_at"
    t.boolean "confirm_status"
    t.datetime "confirm_at"
    t.index ["formulation_id"], name: "index_prescriptions_on_formulation_id"
    t.index ["frequency_id"], name: "index_prescriptions_on_frequency_id"
    t.index ["medication_id"], name: "index_prescriptions_on_medication_id"
    t.index ["patient_id"], name: "index_prescriptions_on_patient_id"
    t.index ["prescriber_id"], name: "index_prescriptions_on_prescriber_id"
    t.index ["unit_id"], name: "index_prescriptions_on_unit_id"
  end

  create_table "read_control_notification_records", force: :cascade do |t|
    t.bigint "control_patient_id", null: false
    t.bigint "control_notification_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_patient_id"], name: "index_read_control_notification_records_on_control_patient_id"
  end

  create_table "read_notification_records", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_read_notification_records_on_notification_id"
    t.index ["patient_id"], name: "index_read_notification_records_on_patient_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.boolean "emergency"
    t.index ["name"], name: "index_symptoms_on_name", unique: true
  end

  create_table "taken_prescription_records", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "prescription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_taken_prescription_records_on_patient_id"
    t.index ["prescription_id"], name: "index_taken_prescription_records_on_prescription_id"
  end

  create_table "tips", force: :cascade do |t|
    t.string "tip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "schedule"
  end

  create_table "twilio_phone_calls", force: :cascade do |t|
    t.string "twilio_sid", null: false
    t.bigint "exacerbation_id"
    t.index ["exacerbation_id"], name: "index_twilio_phone_calls_on_exacerbation_id"
  end

  create_table "unit_types", force: :cascade do |t|
    t.string "kind", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "authentication_token"
    t.datetime "token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0, null: false
    t.boolean "used_mobile_app", default: false
    t.string "unique_session_id", limit: 20
    t.boolean "accept_policy", default: false, null: false
    t.boolean "disabled", default: false, null: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "video_name"
    t.string "url"
    t.integer "week"
    t.integer "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alert_tables", "patients"
  add_foreign_key "clincard_balance_requests", "users"
  add_foreign_key "control_activities", "control_patients"
  add_foreign_key "control_incentive_records", "control_patients"
  add_foreign_key "control_notifications", "users"
  add_foreign_key "control_notifications_control_patients", "control_notifications"
  add_foreign_key "control_notifications_control_patients", "control_patients"
  add_foreign_key "control_patient_reward_records", "control_patients"
  add_foreign_key "control_patient_visits_records", "control_patients"
  add_foreign_key "control_patients", "users"
  add_foreign_key "diet_records", "control_patients"
  add_foreign_key "incentive_records", "patients"
  add_foreign_key "medications", "medication_types", column: "type_id"
  add_foreign_key "patient_reward_records", "patients"
  add_foreign_key "patient_visits_records", "patients"
  add_foreign_key "patients", "users"
  add_foreign_key "prescription_levels", "level_types", column: "level_id"
  add_foreign_key "prescription_levels", "prescriptions"
  add_foreign_key "prescriptions", "formulation_types", column: "formulation_id"
  add_foreign_key "prescriptions", "frequency_types", column: "frequency_id"
  add_foreign_key "prescriptions", "medications"
  add_foreign_key "prescriptions", "patients"
  add_foreign_key "prescriptions", "unit_types", column: "unit_id"
  add_foreign_key "prescriptions", "users", column: "prescriber_id"
  add_foreign_key "read_control_notification_records", "control_notifications"
  add_foreign_key "read_control_notification_records", "control_patients"
end
