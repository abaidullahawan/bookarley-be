class AddColumnInProductCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :product_categories, :is_option, :boolean, default: false
  end
end
