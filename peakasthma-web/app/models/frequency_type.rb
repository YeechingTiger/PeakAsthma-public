class FrequencyType < ApplicationRecord
  has_many :prescriptions
  accepts_nested_attributes_for :prescriptions

  FREQUENCIES = {
    medications: {
      as_needed: 'As needed',
      every_4_6_hrs: 'Every 4-6 hrs',
      four_times_daily: 'Four times daily or every 6 hrs',
      three_times_daily: 'Three times daily or every 8 hrs',
      twice_daily: 'Twice daily or every 12 hrs',
      daily: 'Daily',
      every_other_day: 'Every other day',
      weekly: 'Weekly'
    },
    injections: {
      twice_monthly: 'Twice monthly',
      monthly: 'Monthly'
    }
  }.freeze

  all_frequencies = []
  FREQUENCIES.values.each do |v|
    all_frequencies += v.values
  end
  ALL_FREQUENCIES = all_frequencies.freeze

  validates :kind, presence: true
end
