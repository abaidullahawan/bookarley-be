class AddColumnInCities < ActiveRecord::Migration[6.1]
  def change
    add_column :cities, :city_type, :string
  end
end
