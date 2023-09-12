class Spree::BlogReview < ApplicationRecord
  belongs_to :spree_blog_post, class_name: 'Spree::BlogPost'
end
