# frozen_string_literal: true

# budget Partial JSON
json.id budget.id
json.title budget.title
json.description budget.description
json.status budget.status
json.link budget.link
json.icon budget.icon
json.created_at budget.created_at
json.updated_at budget.updated_at
json.active_image_path budget.active_image.present? ? url_for(budget.active_image.variant(resize_to_limit: [400, 400]).processed) : nil
