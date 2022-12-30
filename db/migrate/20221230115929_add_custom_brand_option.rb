class AddCustomBrandOption < ActiveRecord::Migration[6.1]
  def change
    add_column :brands, :is_listed, :boolean, default: true
  end
end
