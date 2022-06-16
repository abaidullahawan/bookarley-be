class AddLinkToProductTables < ActiveRecord::Migration[6.1]
  def change
    add_column :product_categories, :link, :string
    add_column :product_category_heads, :link, :string
    add_column :product_sub_categories, :link, :string
  end
end
