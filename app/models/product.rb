# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :product_category
  belongs_to :product_sub_category
  has_one_attached :active_image

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
