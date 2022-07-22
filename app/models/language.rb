# frozen_string_literal: true

class Language < ApplicationRecord
  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true
end
