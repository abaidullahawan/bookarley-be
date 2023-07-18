# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  after_create :add_default_role
  before_create :email_required?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :timeoutable, :confirmable,
         :omniauthable, :trackable, :database_authenticatable, authentication_keys: [:phone, :email]
  has_many :users_role
  has_one :personal_detail, as: :bio
  has_one_attached :profile
  has_many :products
  has_many :favourite_ads
  has_many :favourite_products, through: :favourite_ads, source: 'product'
  has_many :reported_ads
  has_many :stores
  accepts_nested_attributes_for :personal_detail
  accepts_nested_attributes_for :users_role
  validates :phone, uniqueness: true, if: -> { phone.present? }

  def self.find_for_database_authentication(conditions={})
    find_by(phone: conditions[:email]) || find_by(email: conditions[:email])
  end

  def add_default_role
    add_role(:customer) if self.roles.blank?
    return unless self.phone.present?

    update_column(:confirmed_at, Time.zone.now)
  end

  def email_required?
    if self.phone.present?
      self.email = "#{Time.now.strftime('%m%d%Y%H%M%p')}Bookarley@demo.co"
    end
  end

	def created_at
    attributes['created_at']&.strftime('%B %d, %Y')
	end

end
