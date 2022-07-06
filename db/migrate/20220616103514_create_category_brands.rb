class CreateCategoryBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :category_brands do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :icon

      t.timestamps
    end
  end
end
