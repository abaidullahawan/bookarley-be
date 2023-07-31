class AddParentIdToSubCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :product_sub_categories, :parent_id, :integer
  end
end
