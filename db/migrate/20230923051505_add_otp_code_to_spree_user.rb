class AddOtpCodeToSpreeUser < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :otp_code, :integer
  end
end
