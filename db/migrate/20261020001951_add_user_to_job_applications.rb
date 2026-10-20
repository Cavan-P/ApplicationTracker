class AddUserToJobApplications < ActiveRecord::Migration[8.1]
  def up
    add_reference :job_applications, :user, foreign_key: true

    first_user_id = select_value("SELECT id FROM users ORDER BY id LIMIT 1")
    execute "UPDATE job_applications SET user_id = #{first_user_id}" if first_user_id

    change_column_null :job_applications, :user_id, false
  end

  def down
    remove_reference :job_applications, :user, foreign_key: true
  end
end
