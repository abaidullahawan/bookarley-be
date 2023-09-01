class CreateInvitationCardCategory < ActiveRecord::Migration[7.0]
  def change
    create_table :invitation_card_categories do |t|
      t.references :invitation_category
      t.references :invitation_card

      t.timestamps
    end
  end
end
