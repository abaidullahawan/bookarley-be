# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  after_create :add_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :timeoutable, :confirmable,
         :omniauthable, :trackable
  has_many :users_role
  has_one :personal_detail, as: :bio
  has_one_attached :profile
  has_many :products
  has_many :favourite_ads
  has_many :favourite_products, through: :favourite_ads, source: 'product'
  accepts_nested_attributes_for :personal_detail
  accepts_nested_attributes_for :users_role


  def add_default_role
    add_role(:customer) if self.roles.blank?
  end

  def created_at
    attributes['created_at'].strftime('%B %d, %Y')
  end
end
