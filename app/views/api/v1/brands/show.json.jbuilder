# frozen_string_literal: true

# Store Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/brands/brand', brand: @brand
end
