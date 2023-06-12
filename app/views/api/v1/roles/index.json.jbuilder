# frozen_string_literal: true

# roles Index JSON
json.status 'Success'

json.data @roles do |role|
  json.partial! '/api/v1/roles/role', role: role
end

json.pagination @pagy
