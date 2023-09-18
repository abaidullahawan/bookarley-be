class AddApprovalFieldsInSpreeProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_products, :is_approved, :boolean
    add_column :spree_products, :is_rejected, :boolean
    add_column :spree_products, :reason, :text
  end
end
