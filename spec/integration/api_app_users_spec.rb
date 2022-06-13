# frozen_string_literal: true

require 'swagger_helper'

describe 'Profile Info API' do
  # For Show method
  path '/api/v1/app_users/{id}' do
    get 'Show User Prodile' do
      tags 'users'
      description 'Show user profile by giving its id'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :id, in: :path, type: :integer
      parameter name: :body, in: :body, schema: {
      }

      response '200', 'Success' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end
end
