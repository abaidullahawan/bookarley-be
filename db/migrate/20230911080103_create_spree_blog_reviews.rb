class CreateSpreeBlogReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_blog_reviews do |t|
      t.string :name
      t.string :city
      t.text :comment
      t.references :spree_blog_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
