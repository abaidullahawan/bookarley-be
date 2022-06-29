# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  has_many :category_brands
  has_many :product_category_heads
  has_many :product_sub_categories, through: :product_category_heads
  has_one_attached :active_image

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
