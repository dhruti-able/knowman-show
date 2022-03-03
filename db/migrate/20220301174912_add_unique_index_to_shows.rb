class AddUniqueIndexToShows < ActiveRecord::Migration[6.1]
  def change
    add_index :shows, [:hall, :start_time], unique: true
  end
end
