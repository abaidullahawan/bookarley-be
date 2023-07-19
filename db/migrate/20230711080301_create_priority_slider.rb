class CreatePrioritySlider < ActiveRecord::Migration[6.1]
  def change
    create_table :priority_sliders do |t|
      t.integer :priority
      t.string :url
      t.timestamps
    end
  end
end
