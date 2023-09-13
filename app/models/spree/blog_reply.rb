class Spree::BlogReply < ApplicationRecord
  belongs_to :spree_blog_reviews, class_name: 'Spree::BlogReview'
end
