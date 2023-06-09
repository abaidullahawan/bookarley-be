# frozen_string_literal: true

# Stores Index JSON
json.status 'Success'

json.data @stores do |store|
  json.partial! '/api/v1/stores/store', store: store

  json.products store.products do |product|
    json.partial! '/api/v1/products/product', product: product
    json.cover_photo_thumbnail product.cover_photo.present? ? url_for(product.cover_photo.variant(resize_to_limit: [200, 200])) : nil
    json.brand do
      json.partial! '/api/v1/brands/brand', brand: product.brand
    end
  end
end

json.pagination @pagy
