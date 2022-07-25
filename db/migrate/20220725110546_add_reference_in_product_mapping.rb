class AddReferenceInProductMapping < ActiveRecord::Migration[6.1]
  def change
    add_reference :product_mappings, :product_category
  end
end
