class AddRatingToSpreeBlogReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_blog_reviews, :rating, :integer
  end
end
