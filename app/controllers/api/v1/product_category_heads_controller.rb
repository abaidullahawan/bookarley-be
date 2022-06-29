# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductCategoryHeadsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product_category_head, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product_category_heads
      # GET /product_category_heads.json
      def index
        @q = ProductCategoryHead.includes(:active_image_attachment).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @product_category_heads = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_category_heads.map { |pch|
            pch.active_image.attached? ? JSON.parse(pch.to_json(include: [:product_category])).merge(
              active_image_path: url_for(pch.active_image)) : JSON.parse(pch.to_json(include: [:product_category]))
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @product_category_heads = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'product_category_heads/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'product_category_heads.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'product_category_heads.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = ProductCategoryHead.column_names
            csv << headers
            @product_category_heads.each do |pch|
              csv << pch.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /product_category_heads/1
      # GET /product_category_heads/1.json
      def show
        if @product_category_head
          render json: {
            status: 'success',
            data: @product_category_head.active_image.attached? ? JSON.parse(
              @product_category_head.to_json(include: [:product_category])).merge(
              active_image_path: url_for(@product_category_head.active_image)) : JSON.parse(
              @product_category_head.to_json(include: [:product_category]))
          }
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
          @product_category_head = ProductCategoryHead.joins(:product_category).includes(:product_category).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_category_head_params
          params.permit(:title, :active_image, :description, :status,
                                                        :product_category_id, :link, :icon)
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
