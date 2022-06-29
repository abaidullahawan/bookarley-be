# frozen_string_literal: true

module Api
  module V1
    # Product Catories api controller
    class ProductCategoriesController < ApplicationController
      #before_action :authenticate_api_v1_user!, except: %i[categories_list categories_brands]
      before_action :set_product_category, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product categories
      # GET /product_categories.json
      def index
        @q = ProductCategory.includes(:active_image_attachment).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @product_categories = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_categories.map { |product_category|
            product_category.active_image.attached? ? product_category.as_json(
              only: %i[id title description status icon]).merge(
              active_image_path: url_for(product_category.active_image)) : product_category.as_json(
                only: %i[id title description status icon])
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @product_categories = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'product_categories/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'product_categories.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'product_categories.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = ProductCategory.column_names
            csv << headers
            @product_categories.each do |pc|
              csv << pc.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
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
        if @product_category.update(product_category_params)
          render_success
        else
          render json: @product_category.errors
        end
      end

      # DELETE /product_categories/1
      # DELETE /product_categories/1.json
      def destroy
        @product_category.destroy

        render json: { notice: 'Product Category was successfully removed.' }
      end

      def categories_list
        @categories_list = ProductCategory.eager_load(:product_brands,
              product_category_heads: [:product_sub_categories]).except(:id, :title,:image, :description, :status,
          :created_at, :updated_at, :link).to_json(include: [:product_brands,
          product_category_heads: {include: :product_sub_categories } ])
        render json: {
          status: 'success',
          data: JSON.parse(@categories_list)
        }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_category
          @product_category = ProductCategory.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_category_params
          params.permit(:title, :active_image, :description, :status, :link, :icon)
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
