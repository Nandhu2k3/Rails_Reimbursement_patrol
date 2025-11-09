class CreateAllowedEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :allowed_emails do |t|
      t.string :email
      t.string :role
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
