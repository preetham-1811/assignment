class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.string :building_name
      t.string :floor
      t.integer :seat
      t.boolean :is_active

      t.timestamps
    end
  end
end
