# frozen_string_literal: true

require 'swagger_helper'

describe 'Product Categories Info API' do
  # for index function

  path '/api/v1/product_categories' do
    get 'Show All Product Categories' do
      tags 'Product Categories'
      description 'Info Related to All Product Categories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :expiry, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string

      response '200', 'All product categories' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  # For Create Method
  path '/api/v1/product_categories' do
    post 'Create Product Categories' do
      tags 'Product Categories'
      description 'Create Product Categories'
      operationId 'postProductCategoriesCreation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
              product_categories: {
                    type: :object,
                    properties: {
                        title: { type: :string },
                        image: { type: :binary },
                        description: { type: :text },
                        status: { type: :string },
                        link: { type: :string }
                        }
                    }
                        }
      }

      response '200', 'Product Category Created' do
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
  path '/api/v1/product_categories/{id}' do
    get 'Show Product Category' do
      tags 'Product Categories'
      description 'Show Product Category by giving its id'
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
  path '/api/v1/product_categories/{id}' do
    put 'Update Product categories' do
      tags 'Product Categories'
      description 'Update Product Category'
      operationId 'putProductCategoryUpdation'
      consumes 'application/json'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: :client, in: :header, type: :string
      parameter name: :uid, in: :header, type: :string
      parameter name: :body, in: :body, schema: {
            type: :object,
            properties: {
                product_category: {
                    type: :object,
                    properties: {
                      title: { type: :string },
                      image: { type: :binary },
                      description: { type: :text },
                      status: { type: :string },
                      link: { type: :string }
                        }
                    }
                        }
      }

      response '200', 'Product Category Created' do
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
  path '/api/v1/product_categories/{id}' do
    delete 'Delete Product Category' do
      tags 'Product Categories'
      description 'Delete a Product category by giving its id'
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
