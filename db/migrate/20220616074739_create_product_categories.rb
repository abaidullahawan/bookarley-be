class CreateProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_categories do |t|
      t.string :title
      t.json :image
      t.text :description
      t.string :status
      t.string :icon

      t.timestamps
    end
  end
end
