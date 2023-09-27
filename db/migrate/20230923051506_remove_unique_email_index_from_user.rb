class RemoveUniqueEmailIndexFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_index "spree_users", name: "email_idx_unique"
  end
end
