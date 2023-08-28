class CreateInvitationCards < ActiveRecord::Migration[7.0]
  def change
    create_table :invitation_cards do |t|
      t.string :card_name

      t.timestamps
    end
  end
end
