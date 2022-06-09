# frozen_string_literal: true

require 'swagger_helper'

describe 'User API' do
  path '/api/v1/auth' do
    post 'Sign Up' do
      tags 'user'
      description 'Creates a User from provided data'
      operationId 'createNewUser'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            }
          }

      response '200', 'User created' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/auth/sign_in' do
    post 'Sign in' do
      tags 'user'
      description 'Sign-in a User from provided data. In response you will get
                    access to the entire application.'
      operationId 'LoggedInUser'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
            }
      }

      response '200', 'User Sign-in' do
        run_test!
      end

      response '422', 'invalid request' do
        run_test!
      end
    end
  end
end
