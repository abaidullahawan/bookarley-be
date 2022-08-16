# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :active_images
  has_one_attached :cover_photo
  belongs_to :brand
  belongs_to :user
  belongs_to :product_category
  has_many :models, dependent: :destroy
  has_many :favourite_ads
  has_many :favourite_users, through: :favourite_ads, source: 'user'

  enum status: {
    active: 'active',
    passive: 'passive',
    deleted: 'deleted'
  }, _prefix: true

  enum product_type: {
    popular: 'popular',
    upcoming: 'upcoming',
    newly_launched: 'newly launched'
  }, _prefix: true

  ransacker :extra_fields do |parent|
    Arel::Nodes::InfixOperation.new('||',
      parent.table[:extra_fields], Arel::Nodes.build_quoted(' ')
    )
  end

  # def updated_at
  #   TimeDifference.between(Time.zone.now, attributes['updated_at']).humanize
  # end

  def as_json
    super.merge('favourite' => favourite_ads.where(user_id: Current.user&.id).present?)
  end
end
