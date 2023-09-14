class CreateSpreeSliders < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_sliders do |t|
      t.string :title
      t.integer :priority
      t.string :url

      t.timestamps
    end
  end
end
