class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :synopsis
      t.integer :release_year
      t.integer :duration
      t.string :director

      t.timestamps
    end
  end
end
