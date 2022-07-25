# frozen_string_literal: true

class ProductMapping < ApplicationRecord
  belongs_to :product_category
end
