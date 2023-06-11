# frozen_string_literal: true

# Brands Index JSON
json.status 'Success'

json.data @brands do |brand|
  json.partial! '/api/v1/brands/brand', brand: brand
end

json.pagination @pagy
