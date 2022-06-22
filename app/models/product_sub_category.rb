# frozen_string_literal: true

class ProductSubCategory < ApplicationRecord
  belongs_to :product_category_head
  has_many :product_categories, through: :product_category_head

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  def as_json
    {
      id: id,
      name: title,
      description: description,
      status: status,
      product_category_head_id: product_category_head_id,
      link: link,
      product_category_head_title: product_category_head.title
    }
   end
end
