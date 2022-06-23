# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductSubCategoriesController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[index]
      before_action :set_product_sub_category, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'

      # GET /product_sub_categories
      # GET /product_sub_categories.json
      def index
        @q = ProductSubCategory.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @product_sub_categories = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @product_sub_categories,
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @product_sub_categories = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'product_sub_categories/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'product_sub_categories.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'product_sub_categories.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = ProductSubCategory.column_names
            csv << headers
            @product_sub_categories.each do |psc|
              csv << psc.as_json.values_at(*headers)
            end
          end
        end
        render json: {
          status: 'success',
          file_path: @save_path
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
