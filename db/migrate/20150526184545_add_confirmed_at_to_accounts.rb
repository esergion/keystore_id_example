class AddConfirmedAtToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :confirmed_at, :datetime
  end
end
