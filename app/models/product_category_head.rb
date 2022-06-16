# frozen_string_literal: true

class ProductCategoryHead < ApplicationRecord
  belongs_to :product_category
  has_many :product_sub_categories

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
