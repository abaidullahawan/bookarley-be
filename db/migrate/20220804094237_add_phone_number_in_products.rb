class AddPhoneNumberInProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :phone_no, :string
  end
end
