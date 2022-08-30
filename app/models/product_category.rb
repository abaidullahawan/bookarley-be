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
    update_column(:link, link + id.to_s) unless link.blank?
  end
end
