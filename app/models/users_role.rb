class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  def as_json
    {
      id: id,
      user_id: user_id,
      role_id: role_id,
      role_name: role.name
    }
  end
end
