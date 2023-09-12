class Spree::BlogPost < ApplicationRecord
  has_one_attached :image
  has_many :spree_blog_reviews, class_name: 'Spree::BlogReview'
end
