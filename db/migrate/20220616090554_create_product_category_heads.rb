class CreateProductCategoryHeads < ActiveRecord::Migration[6.1]
  def change
    create_table :product_category_heads do |t|
      t.string :title
      t.json :image
      t.text :description
      t.string :status
      t.string :icon
      t.string :link

      t.timestamps
    end
  end
end
