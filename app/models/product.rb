# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :active_images
  has_one_attached :cover_photo
  belongs_to :brand
  has_many :models, dependent: :destroy

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  enum product_type: {
    new: 'new',
    used: 'used',
    popular: 'popular',
    featured: 'featured',
    upcoming: 'upcoming',
    newly_launched: 'newly launched'
  }, _prefix: true

  ransacker :extra_fields do |parent|
    Arel::Nodes::InfixOperation.new('||',
      parent.table[:extra_fields], Arel::Nodes.build_quoted(' ')
    )
  end
end
