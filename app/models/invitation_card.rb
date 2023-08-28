# app/models/invitation_card.rb
class InvitationCard < ApplicationRecord
  has_one_attached :image
  serialize :canvas_data, JSON # Store the canvas data as JSON
end
