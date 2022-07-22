# frozen_string_literal: true

class ProductCategoryHead < ApplicationRecord
  belongs_to :product_category
  has_many :product_sub_categories, dependent: :destroy
  has_one_attached :active_image

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
