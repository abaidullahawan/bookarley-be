# frozen_string_literal: true

# budgets Index JSON
json.status 'Success'

json.data @budgets do |budget|
  json.partial! '/api/v1/budgets/budget', budget: budget
end

json.pagination @pagy
