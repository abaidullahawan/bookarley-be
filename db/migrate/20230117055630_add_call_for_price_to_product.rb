class AddCallForPriceToProduct < ActiveRecord::Migration[6.1]
	def change
		add_column :products, :call_for_price, :boolean, default: false
  end
end
