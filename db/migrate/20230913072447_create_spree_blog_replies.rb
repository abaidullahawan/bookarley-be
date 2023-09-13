class CreateSpreeBlogReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_blog_replies do |t|
      t.string :name
      t.text :comment
      t.references :spree_blog_reviews, null: false, foreign_key: true

      t.timestamps
    end
  end
end
