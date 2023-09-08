class AddBlogOverviewToSpreeBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_blog_posts, :blog_overview, :text
  end
end
