# frozen_string_literal: true

# languages Index JSON
json.status 'Success'

json.data @languages do |language|
  json.partial! '/api/v1/languages/language', language: language
end

json.pagination @pagy
