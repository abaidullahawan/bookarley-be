# Stores Index JSON

json.status 'Success'

json.data @stores do |store|
  json.partial! '/api/v1/stores/store', store: store # Product partial
  # json.user do
  #   json.partial! '/api/v1/users/user', user: store.user
  # end

  json.products store.products do |product|
    json.partial! '/api/v1/products/product', product: product # Product partial
    json.cover_photo_thumbnail product.cover_photo.present? ? url_for(product.cover_photo.variant(resize_to_limit: [200, 200])) : nil
  end
end

json.pagination @pagy
