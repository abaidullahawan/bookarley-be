# frozen_string_literal: true

# Store Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/stores/store', store: @store
  json.cover_image @store.cover_image.present? ? url_for(@store.cover_image.variant(resize_to_limit: [851, 315]).processed) : nil


  json.products @store.products do |product|
    json.partial! '/api/v1/products/product', product: product # Product partial
    json.cover_photo_thumbnail product.cover_photo.present? ? url_for(product.cover_photo.variant(resize_to_limit: [200, 200])) : nil
  end
end
