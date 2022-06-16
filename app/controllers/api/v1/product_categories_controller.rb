# frozen_string_literal: true

module Api
  module V1
    # Product Catories api controller
    class ProductCategoriesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product_category, only: %i[show edit update destroy]

      # GET /product categories
      # GET /product_categories.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = ProductCategory.ransack(params[:q])
        @pagy, @product_categories = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_categories,
          pagination: @pagy
        }
      end

      # GET /product_categories/1
      # GET /product_categories/1.json
      def show
        if @product_category
          render_success
        else
          render json: @product_category.errors
        end
      end

      # GET /product_categories/new
      def new
        @product_category = ProductCategory.new
      end

      # GET /product_categories/1/edit
      def edit; end

      # POST /product_category
      # POST /product_category.json
      def create
        @product_category = ProductCategory.new(product_category_params)

        if @product_category.save
          render_success
        else
          render json: @product_category.errors
        end
      end

      # PATCH/PUT /product_categories/1
      # PATCH/PUT /product_categories/1.json
      def update
        respond_to do |format|
          if @product_category.update(product_category_params)
            format.html { redirect_to api_v1_product_category_path(@product_category),
              notice: 'Product Category was successfully updated.' }
            format.json { render :show, status: :ok, location: @product_categories }
          else
            format.html { render :edit }
            format.json { render json: @product_categories.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /product_categories/1
      # DELETE /product_categories/1.json
      def destroy
        @product_category.destroy

        render json: { notice: 'Product Category was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_category
          @product_category = ProductCategory.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_category_params
          params.require(:product_category).permit(:title, :image, :description, :status, :link)
        end

        def render_success
          render json: {
            status: 'success',
            data: @product_category
          }
        end
    end
  end
end
