class AddProductCategoryInProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :product_category
  end
end
