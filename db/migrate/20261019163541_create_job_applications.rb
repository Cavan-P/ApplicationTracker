class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :job_applications do |t|
      t.string :company, null: false
      t.string :role
      t.string :status, null: false, default: "applied"
      t.date :applied_on
      t.string :url
      t.text :notes

      t.timestamps
    end
  end
end
