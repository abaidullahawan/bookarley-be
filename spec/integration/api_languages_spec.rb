# frozen_string_literal: true

require 'swagger_helper'

describe 'Languages Info API' do
  # for index function

  path '/api/v1/languages' do
    get 'Show All Languages' do
      tags 'Languages'
      description 'Info Related to All Languages'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All languages' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/languages' do
    post 'Create Languages' do
      tags 'Languages'
      description 'Create Language'
      operationId 'postLanguageCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
              language: {
                    type: :object,
                    properties: {
                        name: { type: :string },
                        description: { type: :text },
                        status: { type: :string }
                        }
                    }
                        }
      }

      response '200', 'Language Created' do
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
  path '/api/v1/languages/{id}' do
    get 'Show Languages' do
      tags 'Languages'
      description 'Show Languages by giving its id'
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
  path '/api/v1/languages/{id}' do
    put 'Update Languages' do
      tags 'Languages'
      description 'Update Language'
      operationId 'putLanguageUpdation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                language: {
                    type: :object,
                    properties: {
                      name: { type: :string },
                      description: { type: :text },
                      status: { type: :string }
                        }
                    }
                        }
      }

      response '200', 'language Updated' do
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
  path '/api/v1/languages/{id}' do
    delete 'Delete Languages' do
      tags 'Languages'
      description 'Delete Language by giving its id'
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
