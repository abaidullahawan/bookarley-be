class AddIsPendingFieldToSpreeProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_products, :is_pending, :boolean
  end
end
