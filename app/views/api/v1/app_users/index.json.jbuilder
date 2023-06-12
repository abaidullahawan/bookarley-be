# frozen_string_literal: true

# AppUsers Index JSON
json.status 'Success'

json.data @users do |user|
  json.partial! '/api/v1/users/user', user: user

  json.stores user.stores do |store|
    json.partial! '/api/v1/stores/store', store: store
  end

  json.products user.products do |product|
    json.partial! '/api/v1/products/product', product: product
    json.cover_photo_thumbnail product.cover_photo.present? ? url_for(product.cover_photo.variant(resize_to_limit: [200, 200])) : nil
  end
end

json.pagination @pagy
