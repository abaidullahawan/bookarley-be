class Spree::BlogReview < ApplicationRecord
  belongs_to :spree_blog_post, class_name: 'Spree::BlogPost'
  has_many :spree_blog_replies, class_name: 'Spree::BlogReply'
end
