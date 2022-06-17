# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductCategoryHeadsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product_category_head, only: %i[show edit update destroy]

      # GET /product_category_heads
      # GET /product_category_heads.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = ProductCategoryHead.ransack(params[:q])
        @pagy, @product_category_heads = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_category_heads,
          pagination: @pagy
        }
      end

      # GET /product_category_heads/1
      # GET /product_category_heads/1.json
      def show
        if @product_category_head
          render_success
        else
          render json: @product_category_head.errors
        end
      end

      # GET /product_category_heads/new
      def new
        @product_category_head = ProductCategoryHead.new
      end

      # GET /product_category_heads/1/edit
      def edit; end

      # POST /product_category_head
      # POST /product_category_head.json
      def create
        @product_category_head = ProductCategoryHead.new(product_category_head_params)

        if @product_category_head.save
          render_success
        else
          render json: @product_category_head.errors
        end
      end

      # PATCH/PUT /product_category_heads/1
      # PATCH/PUT /product_category_heads/1.json
      def update
        if @product_category_head.update(product_category_head_params)
          render_success
        else
          render json: @product_category_head.errors
        end
      end

      # DELETE /product_category_heads/1
      # DELETE /product_category_heads/1.json
      def destroy
        @product_category_head.destroy

        render json: { notice: 'Product category head was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_category_head
          @product_category_head = ProductCategoryHead.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_category_head_params
          params.require(:product_category_head).permit(:title, :image, :description, :status,
                                                        :product_category_id, :link)
        end

        def render_success
          render json: {
            status: 'success',
            data: @product_category_head
          }
        end
    end
  end
end
