class Bill < ApplicationRecord
  # Every bill belongs to a company for tenant isolation.
  belongs_to :company

  # Every bill is submitted by an employee.
  belongs_to :employee

  # The admin user who reviewed this bill (optional for pending bills).
  # We map "reviewed_by_user_id" to the User model.
  belongs_to :reviewer,
             class_name: "User",
             foreign_key: "reviewed_by_user_id",
             optional: true

  # Amount is required and must be greater than 0.
  validates :amount,
            presence: true,
            numericality: { greater_than: 0 }

  # Bill type is required and must be one of the allowed categories.
  validates :bill_type,
            presence: true,
            inclusion: { in: %w[Food Travel Others] }

  # Status is required and limited to known workflow states.
  validates :status,
            presence: true,
            inclusion: { in: %w[pending approved rejected] }

  # submitted_at must exist when the bill is created.
  validates :submitted_at, presence: true

  # Simple helper to check if this bill is pending.
  def pending?
    status == "pending"
  end

  # Helper to check if approved.
  def approved?
    status == "approved"
  end

  # Helper to check if rejected.
  def rejected?
    status == "rejected"
  end
end