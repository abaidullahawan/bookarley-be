# frozen_string_literal: true

class ProductCategoryHead < ApplicationRecord
  belongs_to :product_category
  has_many :product_sub_categories

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
     product_category_id: product_category_id,
     link: link,
     product_category_title: product_category.title
   }
  end
end

