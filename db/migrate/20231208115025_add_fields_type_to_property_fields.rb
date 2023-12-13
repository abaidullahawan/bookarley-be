class AddFieldsTypeToPropertyFields < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_properties, :field_type, :string
    add_column :spree_properties, :value, :text
  end
end
