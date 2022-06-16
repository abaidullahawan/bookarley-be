# frozen_string_literal: true

class ProductBrand < ApplicationRecord
  has_many :product_categories, through: :category_brands
  has_many :category_brands
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
