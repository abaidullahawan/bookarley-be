# frozen_string_literal: true

# country Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/countries/country', country: @country
end
