class ChangedTableProductBrandToCategoryBrand < ActiveRecord::Migration[6.1]
  def change
    rename_table :product_brands, :category_brands
  end
end
