class CreateProductMapping < ActiveRecord::Migration[6.1]
  def change
    create_table :product_mappings do |t|
      t.string :product_category
      t.json :extra_fields

      t.timestamps
    end
  end
end
