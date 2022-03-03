class CreateHalls < ActiveRecord::Migration[6.1]
  def change
    create_table :halls do |t|
      t.string :name
      t.string :description
      t.integer :capacity

      t.timestamps
    end
  end
end
