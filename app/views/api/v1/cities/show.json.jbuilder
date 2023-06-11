# frozen_string_literal: true

# city Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/cities/city', city: @city
end
