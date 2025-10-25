class CreateImportJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :import_jobs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.text :error_message

      t.timestamps
    end
  end
end
