class Department < ApplicationRecord
  # Each department belongs to a specific company.
  belongs_to :company

  # A department can have many employees assigned to it.
  has_many :employees, dependent: :nullify

  # Department name is required.
  validates :name, presence: true
end