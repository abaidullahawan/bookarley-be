# frozen_string_literal: true

# Budget Show JSON
json.status 'Success'

json.data do
  json.partial! '/api/v1/budgets/budget', budget: @budget
end
