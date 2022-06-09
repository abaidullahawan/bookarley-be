# frozen_string_literal: true

require 'swagger_helper'

describe 'Countries Info API' do
  # for index function

  path '/api/v1/countries' do
    get 'Show All Countries' do
      tags 'Countries'
      description 'Info Related to All Countries'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All Countries' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/countries' do
    post 'Create Country' do
      tags 'countries'
      description 'Create Country'
      operationId 'postCountryCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                plan: {
                    type: :object,
                    properties: {
                        name: { type: :string },
                        comments: { type: :text },
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

  # For Show method
  path '/api/v1/countries/{id}' do
    get 'Show Country' do
      tags 'Countries'
      description 'Show a country by giving its id'
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
  path '/api/v1/countries/{id}' do
    put 'Update Country' do
      tags 'countries'
      description 'Update Country'
      operationId 'putCountryUpdation'
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
                        comments: { type: :text },
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
  path '/api/v1/countries/{id}' do
    delete 'Delete Country' do
      tags 'Countries'
      description 'Delete a country by giving its id'
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
