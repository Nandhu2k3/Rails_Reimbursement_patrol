class User < ApplicationRecord
  # Each user belongs to one company (for multi-tenant isolation).
  belongs_to :company

  # If this user is an employee, they will have one employee profile.
  # (Admins may not have an employee record.)
  has_one :employee, dependent: :destroy

  # Enable password hashing & authentication helpers.
  # This expects a "password_digest" column in the table.
  has_secure_password

  # Basic roles for authorization checks.
  # We store them as plain strings: "admin" or "employee".
  # These helper methods make intent clear in code.
  def admin?
    # Returns true if this user's role is exactly "admin".
    role == "admin"
  end

  def employee?
    # Returns true if this user's role is exactly "employee".
    role == "employee"
  end

  # Validate presence of required fields.
  validates :name, presence: true

  # Email must exist.
  validates :email, presence: true

  # Email format should look like an email (very simple check).
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Role must be either "admin" or "employee".
  validates :role, inclusion: { in: %w[admin employee] }

  # Ensure email is unique within same company (DB index also enforces this).
  validates :email, uniqueness: { scope: :company_id }
end