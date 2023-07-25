class AddAddressToStore < ActiveRecord::Migration[6.1]
  def change
    add_column :stores, :address, :string
  end
end
