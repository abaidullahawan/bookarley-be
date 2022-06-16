class CreateProductBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :product_brands do |t|
      t.string :title
      t.binary :image, :limit => 5.megabyte
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
