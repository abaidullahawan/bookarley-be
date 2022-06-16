# frozen_string_literal: true

class ProductCategoryHead < ApplicationRecord
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
