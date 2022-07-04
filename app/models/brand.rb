# frozen_string_literal: true

class Brand < ApplicationRecord
  has_one_attached :active_image
  has_many :products, dependent: :destroy
  has_many :models ,through: :products, dependent: :destroy

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
