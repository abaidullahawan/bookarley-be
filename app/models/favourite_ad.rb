
# frozen_string_literal: true

class FavouriteAd < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
