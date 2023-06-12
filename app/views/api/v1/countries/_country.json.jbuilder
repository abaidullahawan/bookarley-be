# frozen_string_literal: true

# country Partial JSON
json.id country.id
json.title country.title
json.comments country.comments
json.status country.status
json.created_at country.created_at
json.updated_at country.updated_at
json.active_image_path country.active_image.present? ? url_for(country.active_image.variant(resize_to_limit: [400, 400]).processed) : nil
