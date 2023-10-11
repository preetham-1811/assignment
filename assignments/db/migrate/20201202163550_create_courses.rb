class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :course_code
      t.string :course_name
      t.string :school
      t.integer :offered_year
      t.string :offered_semester
      t.integer :exam_duration
      t.boolean :is_active

      t.timestamps
    end
  end
end
