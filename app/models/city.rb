# frozen_string_literal: true

class City < ApplicationRecord
  has_one_attached :active_image
  # after_create :set_image
  # after_update :set_image
  # include Rails.application.routes.url_helpers

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  private
  # def set_image
  #   image_url = rails_blob_path(self.image_active, disposition: "attachment", only_path: true)
  #   update_columns(image: image_url)
  # end

end
