class AddReferenceProductCategoryInProductCategoryHeads < ActiveRecord::Migration[6.1]
  def change
    add_reference :product_category_heads, :product_category
  end
end
