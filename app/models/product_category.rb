# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end