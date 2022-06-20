# frozen_string_literal: true

class City < ApplicationRecord

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

end
