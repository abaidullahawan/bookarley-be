class AddTitleToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_prices, :title, :string
  end
end
