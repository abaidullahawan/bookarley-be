class AddBgColorToSpreeBlogReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_blog_reviews, :bg_color, :string
  end
end
