class AddOptGeneratedAtToSpreeUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :otp_generated_at, :datetime
    change_column :spree_users, :otp_code, :string
  end
end
