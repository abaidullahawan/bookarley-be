# frozen_string_literal: true

class ReportedAd < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
