# This migration creates the bills table.
# A Bill is a single reimbursement request submitted by an employee.
class CreateBills < ActiveRecord::Migration[5.2]
  # change defines the schema changes to apply when this migration runs.
  def change
    # Create the "bills" table where all reimbursement records are stored.
    create_table :bills do |t|
      # "amount" stores how much money the employee is claiming.
      # precision: 10, scale: 2 means numbers like 12345678.90 are allowed.
      # null: false enforces that every bill must have an amount.
      t.decimal :amount, precision: 10, scale: 2, null: false

      # "bill_type" tells us the category of the expense.
      # Example values: "Food", "Travel", "Others".
      t.string :bill_type, null: false

      # "status" shows where the bill is in the review process.
      # We will use: "pending", "approved", "rejected".
      # Default is "pending" when a bill is first created.
      t.string :status, null: false, default: "pending"

      # "submitted_at" records when the employee submitted the bill.
      t.datetime :submitted_at, null: false

      # "reviewed_at" records when an admin approved/rejected the bill.
      # This can be null if the bill is still pending.
      t.datetime :reviewed_at

      # "company_id" links this bill to the company (tenant) it belongs to.
      # This enforces data isolation between companies.
      t.references :company, null: false, foreign_key: true

      # "employee_id" links to the Employee who submitted the bill.
      t.references :employee, null: false, foreign_key: true

      # "reviewed_by_user_id" stores the ID of the admin User who reviewed it.
      # This is not a foreign_key helper because it points to users table manually.
      t.integer :reviewed_by_user_id

      # Standard Rails timestamps: "created_at" and "updated_at".
      t.timestamps
    end

    # Index on reviewer so we can quickly find bills handled by a specific admin.
    add_index :bills, :reviewed_by_user_id

    # Composite index for fast lookups by employee + status
    # (e.g., "all pending bills for this employee").
    add_index :bills, [:employee_id, :status]
  end
end