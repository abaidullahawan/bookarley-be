class Favorite < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User', foreign_key: 'user_id'
  belongs_to :product, class_name: 'Spree::Product', foreign_key: 'product_id'
end
