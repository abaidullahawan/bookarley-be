class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :title
      t.text :comments
      t.string :status
      t.string :city_type

      t.timestamps
    end
  end
end
