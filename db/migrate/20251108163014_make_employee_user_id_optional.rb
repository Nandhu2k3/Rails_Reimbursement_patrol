class MakeEmployeeUserIdOptional < ActiveRecord::Migration[5.2]
  def change
    # Allow user_id to be NULL on employees table.
    # This means an employee record can exist before a login account is linked.
    change_column_null :employees, :user_id, true
  end
end