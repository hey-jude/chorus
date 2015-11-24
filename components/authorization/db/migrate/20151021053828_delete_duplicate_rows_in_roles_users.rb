class DeleteDuplicateRowsInRolesUsers < ActiveRecord::Migration
  def up
    query = <<-SQL
           DELETE FROM roles_users
               WHERE ctid NOT IN (
                 SELECT min(ctid)
                 FROM roles_users
                GROUP BY role_id, user_id)
            SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def down
  end
end
