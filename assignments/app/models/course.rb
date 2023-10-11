class Course < ApplicationRecord
  has_many :registers
  has_many :users, through: :registers
  has_many :schedules
  has_many :rooms, through: :schedules
end
