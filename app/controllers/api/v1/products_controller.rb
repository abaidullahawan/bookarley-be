# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductsController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[products_range get_products]
      before_action :set_product, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /products
      # GET /products.json
      def index
        @q = Product.includes(:brand, active_images_attachments: :blob,
          cover_photo_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?
        no_of_record = params[:no_of_record] || 10
        @pagy, @products = pagy(@q.result, items: no_of_record)
        @urls = []
        render json: {
          status: 'success',
          data: @products.map { |product|
            (product.active_images.attached? && product.cover_photo.attached?) ? JSON.parse(product.to_json(
              include: [:brand])).merge(active_images_path: product.active_images.map {
                |img| url_for(img) }).as_json.merge(cover_photo_path: url_for(
                  product.cover_photo)) : product.active_images.attached? ? product.as_json.merge(
                  active_images_path: product.active_images.map {
                    |img| url_for(img) }) : product.cover_photo.attached? ? product.as_json.merge(
                    cover_photo_path: url_for(product.cover_photo)) : JSON.parse(product.to_json(include: [:brand]))
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @products = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'products/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'products.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'products.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Product.column_names
            csv << headers
            @products.each do |product|
              csv << product.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /products/1
      # GET /products/1.json
      def show
        if @product
          render json: {
            status: 'success',
            data: (@product.active_images.attached? && @product.cover_photo.attached?) ? @product.as_json.merge(
              active_images_path: @product.active_images.map { |img| url_for(img) }).as_json.merge(
                cover_photo_path: url_for(@product.cover_photo)) : @product.active_images.attached? ? @product.as_json.merge(
                  active_images_path: @product.active_images.map { |img| url_for(img) }) : @product.cover_photo.attached? ? @product.as_json.merge(
                    cover_photo_path: url_for(@product.cover_photo)) : @product.as_json
          }
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

      def get_products
        @q = Product.includes(active_images_attachments: :blob, cover_photo_attachment: :blob).ransack(
          product_type_eq: params[:product_type], featured_eq: params[:featured], city_eq: params[:city], price_lteq: params[:price])
        no_of_record = params[:no_of_record] || 10
        @pagy, @products = pagy(@q.result, items: no_of_record)
        @urls = []
        render json: {
          data: @products.map { |product|
            (product.active_images.attached? && product.cover_photo.attached?) ? product.as_json.merge(
              active_images_path: product.active_images.map { |img| url_for(img) }).as_json.merge(
                cover_photo_path: url_for(product.cover_photo)) : product.active_images.attached? ? product.as_json.merge(
                  active_images_path: product.active_images.map { |img| url_for(img) }) : product.cover_photo.attached? ? product.as_json.merge(
                    cover_photo_path: url_for(product.cover_photo)) : product.as_json
          },
          pagination: @pagy
        }
      end

      def products_range
        from = params[:from]
        to = params[:to]
        @product = Product.where("price Between #{from} AND #{to}") if from.present? && to.present?
        @product = Product.where("price <= ?", to) if to.present? && from.blank?
        @product = Product.where("price >= ?", from) if from.present? && to.blank?
        from.blank? && to.blank? ?  render_errors : render_success
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
          parameters_set = params.permit(:title, :description, :status, :cover_photo, :link, :product_type, :brand_id,
                                          :price, :featured, :city, :location, :extra_fields, active_images: [])
          parameters_set[:extra_fields] = JSON.parse(parameters_set[:extra_fields]) if parameters_set[:extra_fields].present?
          parameters_set
        end

        def render_success
          render json: {
            status: 'success',
            data: @product
          }
        end

        def render_errors
          render json: {
            status: "error"
          }
        end
    end
  end
end
