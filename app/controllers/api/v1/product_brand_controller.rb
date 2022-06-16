# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductBrandsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_pproduct_brand, only: %i[show edit update destroy]

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
        if @pproduct_brand
          render_success
        else
          render json: @pproduct_brand.errors
        end
      end

      # GET /product_brands/new
      def new
        @pproduct_brand = ProductBrand.new
      end

      # GET /product_brands/1/edit
      def edit; end

      # POST /pproduct_brand
      # POST /pproduct_brand.json
      def create
        @pproduct_brand = ProductBrand.new(pproduct_brand_params)

        if @pproduct_brand.save
          render_success
        else
          render json: @pproduct_brand.errors
        end
      end

      # PATCH/PUT /product_brands/1
      # PATCH/PUT /product_brands/1.json
      def update
        respond_to do |format|
          if @pproduct_brand.update(pproduct_brand_params)
            format.html { redirect_to api_v1_product_brands_path(@pproduct_brand),
              notice: 'Product head was successfully updated.' }
            format.json { render :show, status: :ok, location: @pproduct_brand }
          else
            format.html { render :edit }
            format.json { render json: @pproduct_brand.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /product_brands/1
      # DELETE /product_brands/1.json
      def destroy
        @pproduct_brand.destroy

        render json: { notice: 'Product head was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_pproduct_brand
          @pproduct_brand = ProductBrand.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def pproduct_brand_params
          params.require(:pproduct_brand).permit(:title, :image, :description, :status)
        end

        def render_success
          render json: {
            status: 'success',
            data: @pproduct_brand
          }
        end
    end
  end
end
