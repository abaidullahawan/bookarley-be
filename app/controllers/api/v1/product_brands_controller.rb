# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductBrandsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_product_brand, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product_brands
      # GET /product_brands.json
      def index
        @q = ProductBrand.includes(:active_image_attachment).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @product_brands = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_brands.map { |product_brand|
            product_brand.active_image.attached? ? product_brand.as_json(
              only: %i[id title description status icon image product_category_id]).merge(
              active_image_path: url_for(product_brand.active_image)) : product_brand.as_json(
                only: %i[id title description status icon image product_category_id])
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @product_brands = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'product_brands/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'product_brands.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'product_brands.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = ProductBrand.column_names
            csv << headers
            @product_brands.each do |pb|
              csv << pb.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
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
          params.permit(:title, :image, :description, :icon, :product_category_id, :status, :active_image)
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
