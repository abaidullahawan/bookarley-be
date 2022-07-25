# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  has_many :category_brands, dependent: :destroy
  has_many :product_category_heads, dependent: :destroy
  has_many :product_sub_categories, through: :product_category_heads, dependent: :destroy
  has_one_attached :active_image
  has_many :product_mappings

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
