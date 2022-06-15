# frozen_string_literal: true

require 'swagger_helper'

describe 'Roles Info API' do
  # for index function

  path '/api/v1/roles' do
    get 'Show All Roles' do
      tags 'Roles'
      description 'Info Related to All Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All Roles' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/roles' do
    post 'Create Role' do
      tags 'Roles'
      description 'Create Role'
      operationId 'postRoleCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                role: {
                    type: :object,
                    properties: {
                        name: { type: :string },
                        resource_type: { type: :string },
                        resource_id: { type: :integer }
                        }
                    }
                        }
      }

      response '200', 'Role Created' do
        run_test!
      end

      response '404', 'record not found' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Show method
  path '/api/v1/roles/{id}' do
    get 'Show Role' do
      tags 'Roles'
      description 'Show a role by giving its id'
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
  # for update method
  path '/api/v1/roles/{id}' do
    put 'Update Roles' do
      tags 'Roles'
      description 'Update Role'
      operationId 'putRoleUpdation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                country: {
                    type: :object,
                    properties: {
                        name: { type: :string },
                        resource_type: { type: :text },
                        resource_id: { type: :integer }
                        }
                    }
                        }
      }

      response '200', 'Role updated' do
        run_test!
      end

      response '404', 'record not found' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end
  # For Delete Method
  path '/api/v1/roles/{id}' do
    delete 'Delete Role' do
      tags 'Roles'
      description 'Delete a role by giving its id'
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
