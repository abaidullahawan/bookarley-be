class ChangeImageDatatype < ActiveRecord::Migration[6.1]
  def change
    remove_column :cities, :image, :binary
    remove_column :countries, :image, :binary
    remove_column :product_categories, :image, :binary
    remove_column :product_category_heads, :image, :binary
    remove_column :product_sub_categories, :image, :binary
    remove_column :product_brands, :image, :binary


    add_column :cities, :image, :json
    add_column :countries, :image, :json
    add_column :product_categories, :image, :json
    add_column :product_category_heads, :image, :json
    add_column :product_sub_categories, :image, :json
    add_column :product_brands, :image, :json
    add_column :products, :images, :json
  end
end
