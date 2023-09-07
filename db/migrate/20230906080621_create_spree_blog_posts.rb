class CreateSpreeBlogPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_blog_posts do |t|
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end