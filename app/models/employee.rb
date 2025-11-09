class Employee < ApplicationRecord
  # Employee belongs to a company (tenant).
  belongs_to :company

  # Employee can be linked to a User (login account),
  # but at creation time this might not exist yet.
  # So we mark it optional: true.
  belongs_to :user, optional: true

  # Employee belongs to a department.
  belongs_to :department

  # An employee can submit many bills.
  has_many :bills, dependent: :destroy

  # First name is required.
  validates :first_name, presence: true

  # Last name is required.
  validates :last_name, presence: true

  # Email is required.
  validates :email, presence: true

  # Email should look like an email.
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :designation, presence: true

  # Email must be unique per company.
  validates :email, uniqueness: { scope: :company_id }
end