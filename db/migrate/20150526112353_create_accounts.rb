class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :confirmation_token
      t.datetime :confirmation_sent_at

      t.timestamps null: false
    end
  end
end
