class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :country
      t.text :description

      t.timestamps
    end
  end
end
