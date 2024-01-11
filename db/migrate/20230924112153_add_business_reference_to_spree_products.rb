class AddBusinessReferenceToSpreeProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :spree_products, :business, foreign_key: true
  end
end
