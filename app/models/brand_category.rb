# frozen_string_literal: true

class BrandCategory < ApplicationRecord
  belongs_to :brand
  belongs_to :product_category
end
