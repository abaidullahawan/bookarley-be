# frozen_string_literal: true

class Model < ApplicationRecord
  has_one_attached :active_image
  belongs_to :product

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
