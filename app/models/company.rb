class Company < ApplicationRecord
    # A company has many departments under it.
    has_many :departments, dependent: :destroy
  
    # A company has many users (both admins and employees).
    has_many :users, dependent: :destroy
  
    # A company has many employees (HR profiles).
    has_many :employees, dependent: :destroy
  
    # A company has many bills (reimbursement requests).
    has_many :bills, dependent: :destroy
  
    # A company controls which emails are allowed to sign up.
    has_many :allowed_emails, dependent: :destroy
  
    # Ensure every company has a name before saving.
    validates :name, presence: true
  end