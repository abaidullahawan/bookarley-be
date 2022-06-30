class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    drop_table :brands
    create_table :brands do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :link
      t.string :icon

      t.timestamps
    end
  end
end
