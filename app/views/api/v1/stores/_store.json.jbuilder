# frozen_string_literal: true

# Store Partial JSON
json.id store.id
json.description store.description
json.status store.status
json.created_at store.created_at
json.updated_at store.updated_at
json.profile_image store.profile_image.present? ? url_for(store.profile_image.variant(resize_to_limit: [400, 400]).processed) : nil
json.user_id store.user_id
