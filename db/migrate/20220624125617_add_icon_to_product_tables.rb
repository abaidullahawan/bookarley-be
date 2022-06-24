class AddIconToProductTables < ActiveRecord::Migration[6.1]
  def change
    add_column :product_brands, :icon, :string
    add_column :product_categories, :icon, :string
    add_column :product_category_heads, :icon, :string
    add_column :product_sub_categories, :icon, :string
  end
end
