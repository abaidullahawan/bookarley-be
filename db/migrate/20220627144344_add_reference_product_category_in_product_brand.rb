class AddReferenceProductCategoryInProductBrand < ActiveRecord::Migration[6.1]
  def change
    add_reference :product_brands, :product_category
  end
end
