class CategoriesAssociationChange < ActiveRecord::Migration[6.1]
  def change
    remove_reference :product_sub_categories, :product_category_head, index: true 
    add_reference :product_sub_categories, :product_category
  end
end
