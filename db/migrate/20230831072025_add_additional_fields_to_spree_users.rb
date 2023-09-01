class AddAdditionalFieldsToSpreeUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :full_name, :string
    add_column :spree_users, :date_of_birth, :date
    add_column :spree_users, :gender, :string
    add_column :spree_users, :profile_picture, :string
    add_column :spree_users, :location, :string
    add_column :spree_users, :bio, :text
    add_column :spree_users, :contact_information, :string
  end
end
