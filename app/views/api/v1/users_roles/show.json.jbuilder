# frozen_string_literal: true

# users_role Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/users_roles/users_role', users_role: @users_role
end
