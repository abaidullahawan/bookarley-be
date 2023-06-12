# frozen_string_literal: true

# city Partial JSON
json.id city.id
json.title city.title
json.comments city.comments
json.status city.status
json.city_type city.city_type
json.created_at city.created_at
json.updated_at city.updated_at
json.active_image_path city.active_image.present? ? url_for(city.active_image.variant(resize_to_limit: [400, 400]).processed) : nil
