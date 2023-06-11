# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class BrandsController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[brand_with_products index]
      before_action :set_brand, only: %i[show edit update destroy brand_with_products]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      def index
        @q = Brand.includes(:product_categories, :products,
          active_image_attachment: :blob).where(is_listed: true).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @brands = pagy(@q.result.order('brands.updated_at': :desc), items: no_of_record)
        render json: {
          status: 'success',
          data: @brands.map { |brand|
            brand.active_image.attached? ? JSON.parse(brand.to_json(
              include: [:product_categories])).merge(
                active_image_path: url_for(brand.active_image)) : JSON.parse(
                  brand.to_json(include: [:product_categories]))
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @brands = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'brands/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'brands.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'brands.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Brand.column_names
            csv << headers
            @brands.each do |brand|
              csv << brand.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      def show
        if @brand
          render :show
        else
          render json: @brand.errors
        end
      end

      def new
        @brand = Brand.new
      end

      def edit; end

      def create
        @brand = Brand.new(brand_params)
        if @brand.save
          create_brand_category
          render_success
        else
          render json: @brand.errors
        end
      end

      def update
        if @brand.update(brand_params)
          update_brand_category
          render_success
        else
          render json: @brand.errors
        end
      end

      def destroy
        @brand.destroy

        render json: { notice: 'Brand was successfully removed.' }
      end

      def brand_with_products
        render json: {
          status: 'success',
          data: @brand.active_image.attached? ? JSON.parse(@brand.to_json(
              include: [:products])).merge(active_image_path: url_for(
                @brand.active_image)) : JSON.parse(@brand.to_json(include: [:products]))
        }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_brand
          @brand = Brand.includes(:products, active_image_attachment: :blob).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def brand_params
          params.permit(:title, :description, :status, :link, :icon, :active_image)
        end

        def render_success
          render json: {
            status: 'success',
            data: @brand
          }
        end

        def create_brand_category
          if params[:product_category_id].present?
            temp = params[:product_category_id].split(',')
            temp.map { |temp| BrandCategory.find_or_create_by(
              product_category_id: temp, brand_id: @brand.id)}
          end
        end

        def update_brand_category
          if params[:product_category_id].present?
            BrandCategory.where(brand_id: @brand.id).destroy_all
            temp = params[:product_category_id].split(',')
            temp.map { |temp| BrandCategory.find_or_create_by(
              product_category_id: temp, brand_id: @brand.id)}
          end
        end
    end
  end
end
