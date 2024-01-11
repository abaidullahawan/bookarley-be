class AddSocialMediaToBusiness < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :social_media, :string, array: true, default: []
  end
end
