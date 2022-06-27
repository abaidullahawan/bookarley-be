# frozen_string_literal: true

class ProductBrand < ApplicationRecord
  belongs_to :product_category
  has_one_attached :active_image

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
