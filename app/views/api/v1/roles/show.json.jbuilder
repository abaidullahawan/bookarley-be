# frozen_string_literal: true

# role Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/roles/role', role: @role
end
