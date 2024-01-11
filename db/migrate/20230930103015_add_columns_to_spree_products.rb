class AddColumnsToSpreeProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_products, :category, :string
    add_column :spree_products, :sub_category, :string
    add_column :spree_products, :down_payment, :string
    add_column :spree_products, :down_payment_type, :string
    add_column :spree_products, :cancellation_policy, :string
    add_column :spree_products, :minimum_price, :integer
    add_column :spree_products, :maximum_price, :integer
    add_column :spree_products, :capacity, :integer
    add_column :spree_products, :staff, :string, array: true, default: []
    add_column :spree_products, :features, :string, array: true, default: []
  end
end
