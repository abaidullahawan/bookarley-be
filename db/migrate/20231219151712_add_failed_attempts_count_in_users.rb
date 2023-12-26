class AddFailedAttemptsCountInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :failed_attempts_count, :integer
  end
end
