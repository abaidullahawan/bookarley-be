class CreateBrands < ActiveRecord::Migration[6.1]
  def change
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
