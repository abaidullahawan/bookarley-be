class ChangeNameToTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :cities, :name, :title
    rename_column :countries, :name, :title
    rename_column :languages, :name, :title
    rename_column :roles, :name, :title
  end
end
