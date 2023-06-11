# frozen_string_literal: true

# countries Index JSON
json.status 'Success'

json.data @countries do |country|
  json.partial! '/api/v1/countries/country', country: country
end

json.pagination @pagy
