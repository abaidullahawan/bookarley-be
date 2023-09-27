class AddPhoneNumberToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :phone_number, :string
  end
end
