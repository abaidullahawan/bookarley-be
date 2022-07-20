class ChangeColumnChangeRoleTitleToName < ActiveRecord::Migration[6.1]
  def change
    rename_column :roles, :title, :name
  end
end
