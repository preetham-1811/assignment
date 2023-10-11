class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.references :course, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.string :comment

      t.timestamps
    end
  end
end
