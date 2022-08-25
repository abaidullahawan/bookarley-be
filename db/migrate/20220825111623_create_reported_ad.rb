class CreateReportedAd < ActiveRecord::Migration[6.1]
  def change
    create_table :reported_ads do |t|
      t.string :reason
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
  end
end
