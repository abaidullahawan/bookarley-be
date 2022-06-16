class CreateProductCategoryHeads < ActiveRecord::Migration[6.1]
  def change
    create_table :product_category_heads do |t|
      t.string :title
      t.binary :image, :limit => 5.megabyte
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
