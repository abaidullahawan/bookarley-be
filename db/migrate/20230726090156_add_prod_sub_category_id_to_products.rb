class AddProdSubCategoryIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :product_sub_category
  end
end
