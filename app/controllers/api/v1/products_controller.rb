# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product, only: %i[show edit update destroy]

      # GET /products
      # GET /products.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = Product.ransack(params[:q])
        @pagy, @products = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @products,
          pagination: @pagy
        }
      end

      # GET /products/1
      # GET /products/1.json
      def show
        if @product
          render_success
        else
          render json: @product.errors
        end
      end

      # GET /products/new
      def new
        @product = Product.new
      end

      # GET /products/1/edit
      def edit; end

      # POST /product
      # POST /product.json
      def create
        @product = Product.new(product_params)

        if @product.save
          render_success
        else
          render json: @product.errors
        end
      end

      # PATCH/PUT /products/1
      # PATCH/PUT /products/1.json
      def update
        if @product.update(product_params)
          render_success
        else
          render json: @product.errors
        end
      end

      # DELETE /products/1
      # DELETE /products/1.json
      def destroy
        @product.destroy
        render json: { notice: 'Product was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
          params.require(:product).permit(:title, :description, :status,
                                          :price, :location, extra_fields: {})
        end

        def render_success
          render json: {
            status: 'success',
            data: @product
          }
        end
    end
  end
end
