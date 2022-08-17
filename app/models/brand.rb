# frozen_string_literal: true

class Brand < ApplicationRecord
  has_one_attached :active_image
  has_many :products, dependent: :destroy
  has_many :models, through: :products, dependent: :destroy
  has_many :brand_categories
  has_many :product_categories, through: :brand_categories
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
