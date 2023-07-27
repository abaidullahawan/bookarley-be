# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductsController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[index destroy]
      before_action :set_product, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product_sub_categories
      # GET /product_sub_categories.json
      def index
        @q = Product.includes(:product_category, :product_sub_category,
          active_image_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @products = pagy(@q.result.order('products.updated_at': :desc),
          items: no_of_record)
        render json: {
          status: 'success',
          data: @products.map { |psc|
            psc.active_image.attached? ? JSON.parse(psc.to_json(
              include: [:product_category, :product_sub_category])).merge(active_image_path: url_for(
                psc.active_image)) : JSON.parse(psc.to_json(include: [:product_category, :product_sub_category]))
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @products = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'products/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'products.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'products.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Product.column_names
            csv << headers
            @products.each do |psc|
              csv << psc.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /product_sub_categories/1
      # GET /product_sub_categories/1.json
      def show
        if @product
          render json: {
            status: 'success',
            data: @product.active_image.attached? ? JSON.parse(
              @product.to_json(include: [:product_category])).merge(
                active_image_path: url_for(@product.active_image)) : JSON.parse(
                  @product.to_json(include: [:product_category]))
          }
        else
          render json: @product.errors
        end
      end

      # GET /product_sub_categories/new
      def new
        @product = Product.new
      end

      # GET /product_sub_categories/1/edit
      def edit; end

      # POST /product_sub_category
      # POST /product_sub_category.json
      def create
        @product = Product.new(product_params)

        if @product.save
          render_success
        else
          render json: @product.errors
        end
      end

      # PATCH/PUT /product_sub_categories/1
      # PATCH/PUT /product_sub_categories/1.json
      def update
        if @product.update(product_params)
          render_success
        else
          render json: @product.errors
        end
      end

      # DELETE /product_sub_categories/1
      # DELETE /product_sub_categories/1.json
      def destroy
        @product.destroy

        render json: { notice: 'Product sub category was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.joins(:product_category).includes(
            :product_category).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
          params.permit(:title, :active_image, :description, :status,
                                                       :product_category_id, :product_sub_category_id, :link, :icon, :price)
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
