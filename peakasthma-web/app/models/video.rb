class Video < ApplicationRecord
    has_and_belongs_to_many :patients

    validates :video_name, presence: true
    validates :url, presence: true
    validates :week, presence: true
    validates :day, presence: true
end
