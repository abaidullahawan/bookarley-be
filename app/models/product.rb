# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :active_images

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  enum status: {
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
