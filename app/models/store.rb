# frozen_string_literal: true

class Store < ApplicationRecord
  has_one_attached :profile_image
  has_one_attached :cover_image
  has_many :products
  belongs_to :user

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'description', 'created_at', 'id', 'status', 'title', 'updated_at']
  end

  private
  # def set_image
  #   image_url = rails_blob_path(self.image_active, disposition: "attachment", only_path: true)
  #   update_columns(image: image_url)
  # end
end
