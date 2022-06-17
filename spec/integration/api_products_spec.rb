# frozen_string_literal: true

require 'swagger_helper'

describe 'Products Info API' do
  # for index function

  path '/api/v1/products' do
    get 'Show All Products' do
      tags 'Products'
      description 'Info Related to All Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All products' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/products' do
    post 'Create Products' do
      tags 'Products'
      description 'Create Products'
      operationId 'postProductBrandsCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
              products: {
                    type: :object,
                    properties: {
                        title: { type: :string },
                        description: { type: :text },
                        status: { type: :string },
                        price: { type: :float },
                        location: { type: :string },
                        extra_fields: { type: :json }
                        }
                    }
                        }
      }

      response '200', 'Products Created' do
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
  path '/api/v1/products/{id}' do
    get 'Show Products' do
      tags 'Products'
      description 'Show Products by giving its id'
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
  path '/api/v1/products/{id}' do
    put 'Update Products' do
      tags 'Products'
      description 'Update Product Category'
      operationId 'putCategoryBrandsUpdation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                product_brand: {
                    type: :object,
                    properties: {
                      title: { type: :string },
                      description: { type: :text },
                      status: { type: :string },
                      price: { type: :float },
                      location: { type: :string },
                      extra_fields: { type: :json }
                        }
                    }
                        }
      }

      response '200', 'product Created' do
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
  path '/api/v1/products/{id}' do
    delete 'Delete Products' do
      tags 'Products'
      description 'Delete Products by giving its id'
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
