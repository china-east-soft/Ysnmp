class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.integer :frequency
      t.string :method
      t.boolean :data

      t.timestamps
    end
  end
end
