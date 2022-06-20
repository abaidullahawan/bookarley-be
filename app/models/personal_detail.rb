# frozen_string_literal: true

class PersonalDetail < ApplicationRecord
  enum gender: {
    male: 'male',
    female: 'female',
    others: 'others'
  }, _prefix: true

  belongs_to :bio, polymorphic: true
end
