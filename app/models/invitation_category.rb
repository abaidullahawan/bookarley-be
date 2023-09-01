class InvitationCategory < ApplicationRecord
  has_many :invitation_card_categories
  has_many :invitation_cards, through: :invitation_card_categories
  has_one_attached :image
end
