# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  has_many :product_category_heads, dependent: :destroy
  has_many :product_sub_categories, through: :product_category_heads, dependent: :destroy
  has_one_attached :active_image
  has_one :product_mapping, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :brand_categories
  has_many :brands, through: :brand_categories
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
  after_create :set_link

  def set_link
    update_column(:link, '/products?category=' + id.to_s)
  end

	def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "icon", "id", "is_option", "link", "position", "status", "title", "updated_at"]
  end

end
