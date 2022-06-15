# frozen_string_literal: true

class User < ActiveRecord::Base

  rolify
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :timeoutable, :omniauthable,
         :trackable
  include DeviseTokenAuth::Concerns::User
  has_many :user_roles
  has_one :personal_detail, as: :bio
  has_one_attached :profile
  accepts_nested_attributes_for :personal_detail
  accepts_nested_attributes_for :user_roles
end
