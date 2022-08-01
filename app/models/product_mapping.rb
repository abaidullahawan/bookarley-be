# frozen_string_literal: true

class ProductMapping < ApplicationRecord
  validates_uniqueness_of :product_category_id, message: 'is already being used'
  belongs_to :product_category
end
