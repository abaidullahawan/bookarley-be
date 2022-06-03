class CreatePersonalDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :personal_details do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.date :dob
      t.string :country
      t.string :city
      t.integer :gender
      t.references :bio, polymorphic: :true

      t.timestamps
    end
  end
end
