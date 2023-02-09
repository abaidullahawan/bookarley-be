class AddUserVarifiedToUserTabel < ActiveRecord::Migration[6.1]
  def change
		add_column :users, :varified_user, :boolean, default: false
  end
end
