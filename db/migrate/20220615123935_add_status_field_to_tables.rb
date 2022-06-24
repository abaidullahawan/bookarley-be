class AddStatusFieldToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :cities, :status, :string
    add_column :cities, :image, :json
    add_column :countries, :status, :string
    add_column :countries, :image, :json
    add_column :roles, :status, :string
  end
end
