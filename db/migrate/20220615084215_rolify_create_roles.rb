class RolifyCreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table(:roles) do |t|
      t.string :title
      t.string :status
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:users_roles) do |t|
      t.references :user
      t.references :role

      t.timestamps
    end

    add_index(:roles, [ :title, :status, :resource_type, :resource_id ])
    add_index(:users_roles, [ :user_id, :role_id ])
  end
end
