# frozen_string_literal: true

# Brand Partial JSON
json.id brand.id
json.title brand.title
json.description brand.description
json.status brand.status
json.link brand.link
json.icon brand.icon
json.created_at brand.created_at
json.updated_at brand.updated_at
json.is_listed brand.is_listed
json.active_image_path brand.active_image.present? ? url_for(brand.active_image.variant(resize_to_limit: [400, 400]).processed) : nil
