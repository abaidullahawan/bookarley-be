class ChangeDataTypeForStatus < ActiveRecord::Migration[6.1]
  def up
    change_column :cities, :status, :string
    change_column :countries, :status, :string
    change_column :roles, :status, :string
  end

  def down
    change_column :cities, :status, :integer, using: 'status::integer'
    change_column :countries, :status, :integer, using: 'status::integer'
    change_column :roles, :status, :integer, using: 'status::integer'
  end
end
