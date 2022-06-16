class AddReferenceProductCategoryHeadInProductSubCategories < ActiveRecord::Migration[6.1]
  def change
    add_reference :product_sub_categories, :product_category_head
  end
end
