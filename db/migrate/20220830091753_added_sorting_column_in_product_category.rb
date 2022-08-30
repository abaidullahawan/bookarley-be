class AddedSortingColumnInProductCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :product_categories, :position, :integer
  end
end
