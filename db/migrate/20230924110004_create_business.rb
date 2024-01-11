class CreateBusiness < ActiveRecord::Migration[7.0]
  def change
      create_table :businesses do |t|
        t.string   "owner_name"
        t.string   "brand_name"
        t.string   "email"
        t.string   "phone"
        t.string   "website"
        t.string   "city"
        t.string   "category"
        t.string   "sub_category"
        t.string   "expertise"
        t.string   "amenties"
        t.text     "description"
      t.timestamps
    end
  end
end
