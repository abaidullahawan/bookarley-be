class CreateInvitationCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :invitation_categories do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
  end
end
