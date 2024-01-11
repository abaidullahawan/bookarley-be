class Business < ApplicationRecord
  has_many :spree_products
  has_one_attached :image
end
