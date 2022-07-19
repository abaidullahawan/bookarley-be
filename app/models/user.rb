# frozen_string_literal: true

class User < ActiveRecord::Base

  rolify
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :timeoutable, :confirmable,
         :omniauthable, :trackable
  has_many :users_role
  has_one :personal_detail, as: :bio
  has_one_attached :profile
  accepts_nested_attributes_for :personal_detail
  accepts_nested_attributes_for :users_role
end
