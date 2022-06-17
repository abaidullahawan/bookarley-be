# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductSubCategoriesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product_sub_category, only: %i[show edit update destroy]

      # GET /product_sub_categories
      # GET /product_sub_categories.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = ProductSubCategory.ransack(params[:q])
        @pagy, @product_sub_categories = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_sub_categories,
          pagination: @pagy
        }
      end

      # GET /product_sub_categories/1
      # GET /product_sub_categories/1.json
      def show
        if @product_sub_category
          render_success
        else
          render json: @product_sub_category.errors
        end
      end

      # GET /product_sub_categories/new
      def new
        @product_sub_category = ProductSubCategory.new
      end

      # GET /product_sub_categories/1/edit
      def edit; end

      # POST /product_sub_category
      # POST /product_sub_category.json
      def create
        @product_sub_category = ProductSubCategory.new(product_sub_category_params)

        if @product_sub_category.save
          render_success
        else
          render json: @product_sub_category.errors
        end
      end

      # PATCH/PUT /product_sub_categories/1
      # PATCH/PUT /product_sub_categories/1.json
      def update
        if @product_sub_category.update(product_sub_category_params)
          render_success
        else
          render json: @product_sub_category.errors
        end
      end

      # DELETE /product_sub_categories/1
      # DELETE /product_sub_categories/1.json
      def destroy
        @product_sub_category.destroy

        render json: { notice: 'Product sub category was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_sub_category
          @product_sub_category = ProductSubCategory.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_sub_category_params
          params.require(:product_sub_category).permit(:title, :image, :description, :status,
                                                       :product_category_head_id, :link)
        end

        def render_success
          render json: {
            status: 'success',
            data: @product_sub_category
          }
        end
    end
  end
end
