# frozen_string_literal: true

class PersonalDetail < ApplicationRecord
  enum gender: %i[MALE FEMALE OTHERS]
  belongs_to :bio, polymorphic: true
end
