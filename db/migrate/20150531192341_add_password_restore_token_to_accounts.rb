class AddPasswordRestoreTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :password_restore_token, :string
    add_column :accounts, :restore_token_sent_at, :datetime
  end
end
