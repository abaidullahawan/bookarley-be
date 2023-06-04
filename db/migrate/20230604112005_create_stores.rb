class CreateStores < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    create_table :stores do |t|
      t.string :title, null: false
      t.text :description
      t.string :status
      t.references :user

      t.timestamps
    end

    change_table :products do |t|
      t.references :store, null: true
    end
  end
end
