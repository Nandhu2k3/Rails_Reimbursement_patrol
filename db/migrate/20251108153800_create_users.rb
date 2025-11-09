class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :role
      t.string :password_digest
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
