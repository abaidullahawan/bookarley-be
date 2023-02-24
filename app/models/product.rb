# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :active_images
  has_one_attached :cover_photo
	# when the rent category is selected
  has_one_attached :driver_photo
  belongs_to :brand
  belongs_to :user
  belongs_to :product_category
  has_many :models, dependent: :destroy
  has_many :favourite_ads
  has_many :favourite_users, through: :favourite_ads, source: 'user'
  has_many :reported_ads
  scope :with_favourite_products, -> { where("favourite_ads.user_id = ?", Current.user.id) }

  enum status: {
    active: 'active',
    inactive: 'in-active'
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

  def updated_at
    TimeDifference.between(Time.zone.now, attributes['updated_at']).humanize
  end

  def as_json(data = {})
    favourite = super.merge(user: user, brand: brand, product_category: product_category)
    return favourite if data.present?

    favourite.merge('favourite' => favourite_ads.where(user_id: Current.user&.id).present?)
  end
	def self.ransackable_attributes(auth_object = nil)
    ["brand_id", "call_for_price", "city", "created_at", "description", "extra_fields", "featured", "id", "link", "location", "phone_no", "price", "price_currency", "product_category_id", "product_type", "status", "title", "updated_at", "user_id"]
  end

end
