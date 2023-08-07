class AddFieldsToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :description, :text
    add_column :categories, :url, :string
    add_column :categories, :status, :boolean
  end
end
