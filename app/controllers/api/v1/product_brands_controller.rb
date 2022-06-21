# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductBrandsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product_brand, only: %i[show edit update destroy]

      # GET /product_brands
      # GET /product_brands.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = ProductBrand.ransack(params[:q])
        @pagy, @product_brands = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_brands,
          pagination: @pagy
        }
      end

      # GET /product_brands/1
      # GET /product_brands/1.json
      def show
        if @product_brand
          render_success
        else
          render json: @product_brand.errors
        end
      end

      # GET /product_brands/new
      def new
        @product_brand = ProductBrand.new
      end

      # GET /product_brands/1/edit
      def edit; end

      # POST /pproduct_brand
      # POST /pproduct_brand.json
      def create
        @product_brand = ProductBrand.new(product_brand_params)

        if @product_brand.save
          render_success
        else
          render json: @product_brand.errors
        end
      end

      # PATCH/PUT /product_brands/1
      # PATCH/PUT /product_brands/1.json
      def update
        if @product_brand.update(product_brand_params)
          render_success
        else
          render json: @product_brand.errors
        end
      end

      # DELETE /product_brands/1
      # DELETE /product_brands/1.json
      def destroy
        @product_brand.destroy

        render json: { notice: 'Product Brand was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_brand
          @product_brand = ProductBrand.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_brand_params
          params.require(:product_brand).permit(:title, :image, :description, :status)
        end

        def render_success
          render json: {
            status: 'success',
            data: @product_brand
          }
        end
    end
  end
end