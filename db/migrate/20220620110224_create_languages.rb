class CreateLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :languages do |t|
      t.string :title
      t.text :description
      t.string :status


      t.timestamps
    end
  end
end
