class AddCanvasDataToInvitationCards < ActiveRecord::Migration[7.0]
  def change
    add_column :invitation_cards, :canvas_data, :text
  end
end
