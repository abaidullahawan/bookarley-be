# app/models/invitation_card.rb
class InvitationCard < ApplicationRecord
  has_one_attached :image
  has_many :invitation_card_categories
  has_many :invitation_categories, through: :invitation_card_categories
  serialize :canvas_data, JSON
end
