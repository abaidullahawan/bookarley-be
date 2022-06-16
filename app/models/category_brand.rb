# frozen_string_literal: true

class CategoryBrand < ApplicationRecord
  belongs_to :product_category
  belongs_to :product_brand
end
