# frozen_string_literal: true

# AppUser Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/users/user', user: @app_user

  json.products @app_user.products do |product|
    json.partial! '/api/v1/products/product', product: product
  end
end
