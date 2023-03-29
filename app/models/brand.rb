# frozen_string_literal: true

class Brand < ApplicationRecord
  has_one_attached :active_image
  has_many :products, dependent: :destroy
  has_many :models, through: :products, dependent: :destroy
  has_many :brand_categories
  has_many :product_categories, through: :brand_categories
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

	def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "icon", "id", "is_listed", "link", "status", "title", "updated_at"]
  end
end
