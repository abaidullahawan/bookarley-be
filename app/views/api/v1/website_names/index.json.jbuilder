# frozen_string_literal: true

# website_names Index JSON
json.status 'Success'

json.data @website_names do |website_name|
  json.partial! '/api/v1/website_names/website_name', website_name: website_name
end
