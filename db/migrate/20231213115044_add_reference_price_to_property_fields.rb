class AddReferencePriceToPropertyFields < ActiveRecord::Migration[7.0]
  def change
    add_reference :spree_product_properties, :price, index: true
  end
end
