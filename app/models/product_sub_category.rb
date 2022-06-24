# frozen_string_literal: true

class ProductSubCategory < ApplicationRecord
  belongs_to :product_category_head
  has_many :product_categories, through: :product_category_head

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

end
