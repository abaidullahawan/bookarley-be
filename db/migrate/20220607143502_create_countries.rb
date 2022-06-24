class CreateCountries < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.string :title
      t.text :comments


      t.timestamps
    end
  end
end
