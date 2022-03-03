class CreateShows < ActiveRecord::Migration[6.1]
  def change
    create_table :shows do |t|
      t.string :name
      t.string :description
      t.boolean :cancelled, default: false
      t.boolean :confirmed, default: false
      t.datetime :start_time
      t.datetime :end_time

      t.references :hall, null: false, foreign_key: true

      t.timestamps
    end
  end
end
