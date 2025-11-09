class AddDesignationToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :designation, :string
  end
end