class InvitationCardCategory < ApplicationRecord
  belongs_to :invitation_card
  belongs_to :invitation_category
end
