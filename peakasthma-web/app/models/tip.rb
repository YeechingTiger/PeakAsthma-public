class Tip < ApplicationRecord
    validates :tip, presence: true
    validates :schedule, presence: true
end
