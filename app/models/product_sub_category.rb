# frozen_string_literal: true

class ProductSubCategory < ApplicationRecord
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
