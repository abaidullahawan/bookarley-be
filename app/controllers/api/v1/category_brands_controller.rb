# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class CategoryBrandsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_category_brand, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /category_brands
      # GET /category_brands.json
      def index
        @q = CategoryBrand.includes(:active_image_attachment).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @category_brands = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @category_brands.map { |category_brand|
            category_brand.active_image.attached? ? category_brand.as_json(
              only: %i[id title description status icon image product_category_id]).merge(
              active_image_path: url_for(category_brand.active_image)) : category_brand.as_json(
                only: %i[id title description status icon image product_category_id])
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @category_brands = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'category_brands/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'category_brands.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'category_brands.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = CategoryBrand.column_names
            csv << headers
            @category_brands.each do |pb|
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

      # GET /category_brands/1
      # GET /category_brands/1.json
      def show
        if @category_brand
          render_success
        else
          render json: @category_brand.errors
        end
      end

      # GET /category_brands/new
      def new
        @category_brand = CategoryBrand.new
      end

      # GET /category_brands/1/edit
      def edit; end

      # POST /category_brand
      # POST /category_brand.json
      def create
        @category_brand = CategoryBrand.new(category_brand_params)

        if @category_brand.save
          render_success
        else
          render json: @category_brand.errors
        end
      end

      # PATCH/PUT /category_brands/1
      # PATCH/PUT /category_brands/1.json
      def update
        if @category_brand.update(category_brand_params)
          render_success
        else
          render json: @category_brand.errors
        end
      end

      # DELETE /category_brands/1
      # DELETE /category_brands/1.json
      def destroy
        @category_brand.destroy

        render json: { notice: 'category Brand was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_category_brand
          @category_brand = CategoryBrand.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def category_brand_params
          params.permit(:title, :image, :description, :icon, :product_category_id, :status, :active_image)
        end

        def render_success
          render json: {
            status: 'success',
            data: @category_brand
          }
        end
    end
  end
end
