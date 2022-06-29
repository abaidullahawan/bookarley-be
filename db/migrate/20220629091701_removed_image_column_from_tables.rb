class RemovedImageColumnFromTables < ActiveRecord::Migration[6.1]
  def change
    remove_column :cities, :image, :json
    remove_column :countries, :image, :json
    remove_column :product_categories, :image, :json
    remove_column :category_brands, :image, :json
    remove_column :product_sub_categories, :image, :json
    remove_column :product_category_heads, :image, :json
    remove_column :products, :images, :json
  end
end
