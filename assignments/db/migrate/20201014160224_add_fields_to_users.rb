class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_admin?, :boolean, default: false
    add_column :users, :is_professor?, :boolean, default: false
    add_column :users, :is_user?, :boolean, default: true
  end
end
