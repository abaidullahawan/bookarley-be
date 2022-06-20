class ChangeDataTypeForGender < ActiveRecord::Migration[6.1]
  def up
    change_column :personal_details, :gender, :string
  end

  def down
    change_column :personal_details, :gender, :integer, using: 'gender::integer'
  end
end
