class AddUserReferenceToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :spree_products, :spree_user, foreign_key: true
  end
end
