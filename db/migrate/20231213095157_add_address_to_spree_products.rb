class AddAddressToSpreeProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_products, :address, :text
    add_column :spree_products, :pin_point, :text
  end
end
