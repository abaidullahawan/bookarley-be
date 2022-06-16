# frozen_string_literal: true

require 'swagger_helper'

describe 'Product Category Heads Info API' do
  # for index function

  path '/api/v1/product_category_heads' do
    get 'Show All Product Category Heads' do
      tags 'Product Category Heads'
      description 'Info Related to All Product Category Heads'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All product category  heads' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/product_category_heads' do
    post 'Create Product Category Heads' do
      tags 'Product Category Heads'
      description 'Create Product Category Heads'
      operationId 'postProductCategoryHeadsCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
              product_category_heads: {
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

      response '200', 'Product Category Heads Created' do
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
  path '/api/v1/product_category_heads/{id}' do
    get 'Show Product Category Heads' do
      tags 'Product Category Heads'
      description 'Show Product Category Heads by giving its id'
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
  path '/api/v1/product_category_heads/{id}' do
    put 'Update Product Category Heads' do
      tags 'Product Category Heads'
      description 'Update Product Category'
      operationId 'putProductCategoryHeadsUpdation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                product_category_heads: {
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

      response '200', 'Product Category Heads Created' do
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
  path '/api/v1/product_category_heads/{id}' do
    delete 'Delete Product Category Heads' do
      tags 'Product Category Heads'
      description 'Delete a Product Category Heads by giving its id'
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
