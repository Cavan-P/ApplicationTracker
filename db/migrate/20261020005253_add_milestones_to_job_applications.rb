class AddMilestonesToJobApplications < ActiveRecord::Migration[8.1]
  def change
    add_column :job_applications, :responded_on, :date
    add_column :job_applications, :interviewed_on, :date
  end
end
