# frozen_string_literal: true

# language Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/languages/language', language: @language
end
