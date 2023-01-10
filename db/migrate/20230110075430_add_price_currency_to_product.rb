class AddPriceCurrencyToProduct < ActiveRecord::Migration[6.1]
  def change
		add_column :products, :price_currency, :string, default: 'PKR'
  end
end
