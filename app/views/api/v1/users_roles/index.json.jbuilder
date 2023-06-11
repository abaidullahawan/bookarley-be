# frozen_string_literal: true

# users_roles Index JSON
json.status 'Success'

json.data @user_roles do |users_role|
  json.partial! '/api/v1/users_roles/users_role', users_role: users_role
end

json.pagination @pagy
