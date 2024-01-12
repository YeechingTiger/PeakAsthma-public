class Guardian < ApplicationRecord
  belongs_to :patient
  belongs_to :user

  accepts_nested_attributes_for :user

  RELATIONSHIP_TO_PATIENT_TYPES = [:child_parent, :grandparent, :self, :other].freeze
  RELATIONSHIP_TO_PATIENT_TYPES_TEXT = [[:child_parent, "Parent"], [:grandparent, "Grandparent"], [:self, "Self"], [:other, "Other"]].freeze
  enum relationship_to_patient: RELATIONSHIP_TO_PATIENT_TYPES

  NOTIFICATION_TYPES = {
    text_email: 'Text + Email',
    phonecall_email: 'Phone Call + Email',
  }.freeze

  all_units = []
  NOTIFICATION_TYPES.values.each do |v|
    all_units += [v]
  end

  ALL_NOTIFICATION_TYPES = all_units.freeze
  enum notification_type: ALL_NOTIFICATION_TYPES

  validates :relationship_to_patient, presence: true
  validates :phone, format: { with: /\A^[1-9]\d{2}-\d{3}-\d{4}\z/, message: "Please enter phone number in correct format: 123-456-7890"}, presence: true
  validates :notification_type, presence: true
end
