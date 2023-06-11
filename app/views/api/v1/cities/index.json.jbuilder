# frozen_string_literal: true

# cities Index JSON
json.status 'Success'

json.data @cities do |city|
  json.partial! '/api/v1/cities/city', city: city
end

json.pagination @pagy
