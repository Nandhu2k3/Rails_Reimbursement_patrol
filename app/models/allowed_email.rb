class AllowedEmail < ApplicationRecord
  # Allowed email entry belongs to a company.
  belongs_to :company

  # Email is required.
  validates :email, presence: true

  # Email should be in valid format.
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Role is required (e.g., "employee" or "admin").
  validates :role, presence: true

  # Only allow specific roles so we don't accidentally create junk roles.
  validates :role, inclusion: { in: %w[employee admin] }

  # Ensure the same email is not entered twice for a company.
  validates :email, uniqueness: { scope: :company_id }
end