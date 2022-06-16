class CreateCategoryBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :category_brands do |t|
      t.references :product_categories
      t.references :product_brands

      t.timestamps
    end
  end
end
