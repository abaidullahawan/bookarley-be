# frozen_string_literal: true

require 'swagger_helper'

describe 'Product Brands Info API' do
  # for index function

  path '/api/v1/product_brands' do
    get 'Show All Product Brands' do
      tags 'Product Brands'
      description 'Info Related to All Product Brands'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All product  brands' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/product_brands' do
    post 'Create Product Brands' do
      tags 'Product Brands'
      description 'Create Product Brands'
      operationId 'postProductBrandsCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
              product_brands: {
                    type: :object,
                    properties: {
                        title: { type: :string },
                        image: { type: :binary },
                        description: { type: :text },
                        status: { type: :string }
                        }
                    }
                        }
      }

      response '200', 'Product Brands Created' do
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
  path '/api/v1/product_brands/{id}' do
    get 'Show Product Brands' do
      tags 'Product Brands'
      description 'Show Product Brands by giving its id'
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
  path '/api/v1/product_brands/{id}' do
    put 'Update Product Brands' do
      tags 'Product Brands'
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
                      image: { type: :binary },
                      description: { type: :text },
                      status: { type: :string }
                        }
                    }
                        }
      }

      response '200', 'Category Brands Created' do
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
  path '/api/v1/product_brands/{id}' do
    delete 'Delete Product Brands' do
      tags 'Product Brands'
      description 'Delete Product Brands by giving its id'
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
