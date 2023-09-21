class AddIsFavouriteToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_products, :is_favourite, :boolean
  end
end
