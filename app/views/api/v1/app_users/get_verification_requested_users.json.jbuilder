# frozen_string_literal: true

json.status 'Success'

json.data @users do |user|
  json.partial! '/api/v1/users/user', user: user
end

json.req_varified @req_varified

json.pagination @pagy
