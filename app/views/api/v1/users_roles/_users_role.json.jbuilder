# frozen_string_literal: true

# users_role Partial JSON
json.id users_role.id
json.role_id users_role.role_id
json.user_id users_role.user_id
json.created_at users_role.created_at
json.updated_at users_role.updated_at

json.role users_role.role

json.user do
  json.id users_role.user.id
  json.provider users_role.user.provider
  json.uid users_role.user.uid
  json.allow_password_change users_role.user.allow_password_change
  json.name users_role.user.name
  json.nickname users_role.user.nickname
  json.image users_role.user.image
  json.email users_role.user.email
  json.phone users_role.user.phone
  json.created_at users_role.user.created_at
  json.updated_at users_role.user.updated_at
  json.varified_user users_role.user.varified_user
  json.personal_detail users_role.user.personal_detail
  json.profile_path users_role.user.profile.present? ? url_for(users_role.user.profile) : nil
end
