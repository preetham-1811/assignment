class AddStartTimeToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :start_time, :datetime
  end
end
