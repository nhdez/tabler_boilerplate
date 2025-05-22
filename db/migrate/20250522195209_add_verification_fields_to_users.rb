class AddVerificationFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :verified, :boolean, default: false
    add_column :users, :verified_at, :datetime
    add_column :users, :verification_token, :string
    add_index :users, :verification_token, unique: true
  end
end
