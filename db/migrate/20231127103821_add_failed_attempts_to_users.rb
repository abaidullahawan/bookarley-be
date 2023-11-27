class AddFailedAttemptsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :last_login_attempt_at, :datetime
  end
end
