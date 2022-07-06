class AddReferenceProductCategoryInProductBrand < ActiveRecord::Migration[6.1]
  def change
    add_reference :category_brands, :product_category
  end
end
