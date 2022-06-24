class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.json :extra_fields
      t.text :description
      t.string :status
      t.string :link
      t.string :location
      t.json :images

      t.timestamps
    end
  end
end
