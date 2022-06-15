class AddStatusFieldToTables < ActiveRecord::Migration[6.1]
  def change
    add_column :cities, :status, :integer
    add_column :cities, :image, :binary,  :limit => 5.megabyte
    add_column :countries, :status, :integer
    add_column :countries, :image, :binary,  :limit => 5.megabyte
    add_column :roles, :status, :integer
  end
end
