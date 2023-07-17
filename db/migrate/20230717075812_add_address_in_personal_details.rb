class AddAddressInPersonalDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :personal_details, :address, :text
  end
end
