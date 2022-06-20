class AddColumnsToPersonalDetail < ActiveRecord::Migration[6.1]
  def change
    add_column :personal_details, :phone_number, :string
    add_column :personal_details, :language, :string
  end
end
