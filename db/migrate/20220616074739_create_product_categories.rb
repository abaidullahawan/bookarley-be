class CreateProductCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :product_categories do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :icon
      t.string :link

      t.timestamps
    end
  end
end
