class AddRefernceProductInModel < ActiveRecord::Migration[6.1]
  def change
    add_reference :models, :product
  end
end
