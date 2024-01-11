class AddFeatureDataToSpreeProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_products, :feature_data, :jsonb, default: {}
  end
end
