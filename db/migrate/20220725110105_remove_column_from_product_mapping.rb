class RemoveColumnFromProductMapping < ActiveRecord::Migration[6.1]
  def change
    remove_column :product_mappings, :product_category, :string
  end
end
