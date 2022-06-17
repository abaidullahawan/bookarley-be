# frozen_string_literal: true

class Product < ApplicationRecord
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  ransacker :extra_fields do |parent|
    Arel::Nodes::InfixOperation.new('||',
      parent.table[:extra_fields], Arel::Nodes.build_quoted(' ')
    )
  end
end
