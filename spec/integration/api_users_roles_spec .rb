# frozen_string_literal: true

require 'swagger_helper'

describe 'Users Roles Info API' do
  # for index function

  path '/api/v1/users_roles' do
    get 'Show All Users Roles' do
      tags 'Users Roles'
      description 'Info Related to All Users Roles'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All Users Roles' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/users_roles' do
    post 'Create Users Roles' do
      tags 'Users Roles'
      description 'Create Users Roles'
      operationId 'postUsers RolesCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                users_role: {
                    type: :object,
                    properties: {
                        user_id: { type: :integer },
                        role_id: { type: :integer },
                        }
                    }
                        }
      }

      response '200', 'Users Role Created' do
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
  path '/api/v1/users_roles/{id}' do
    get 'Show Users Role' do
      tags 'Users Roles'
      description 'Show a Users Role by giving its id'
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
  path '/api/v1/users_roles/{id}' do
    put 'Update Users Role' do
      tags 'Users Roles'
      description 'Update Users Role'
      operationId 'putUsers RoleUpdation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                users_role: {
                    type: :object,
                    properties: {
                        user_id: { type: :integer },
                        role_id: { type: :integer }
                        }
                    }
                        }
      }

      response '200', 'Country Created' do
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
  path '/api/v1/users_roles/{id}' do
    delete 'Delete Users Role' do
      tags 'Users Roles'
      description 'Delete a Users Role by giving its id'
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
