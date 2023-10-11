class AddEndTimeToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :end_time, :datetime
  end
end
