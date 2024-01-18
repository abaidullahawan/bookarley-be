class AddProviderAndUidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :provider, :string
    add_column :spree_users, :uid, :string
  end
end
