# frozen_string_literal: true

module Api
  module V1
    # Product Mappings api controller
    class ProductMappingsController < ApplicationController
      #before_action :authenticate_api_v1_user!
      before_action :set_product_mapping, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product mappings
      # GET /product_mappings.json
      def index
        @q = ProductMapping.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @product_mappings = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data:  JSON.parse(@product_mappings.includes(:product_category).to_json(
            include: [:product_category])),
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @product_mappings = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'product_mappings/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'product_mappings.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'product_mappings.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = ProductMapping.column_names
            csv << headers
            @product_mappings.each do |pc|
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

      # GET /product_mappings/1
      # GET /product_mappings/1.json
      def show
        if @product_mapping
          render json: {
            status: 'success',
            data: @product_mapping
          }
        else
          render json: @product_mapping.errors
        end
      end

      # GET /product_mappings/new
      def new
        @product_mapping = ProductMapping.new
      end

      # GET /product_mappings/1/edit
      def edit; end

      # POST /product_mapping
      # POST /product_mapping.json
      def create
        @product_mapping = ProductMapping.new(product_mapping_params)

        if @product_mapping.save
          render_success
        else
          render json: @product_mapping.errors
        end
      end

      # PATCH/PUT /product_mappings/1
      # PATCH/PUT /product_mappings/1.json
      def update
        if @product_mapping.update(product_mapping_params)
          render_success
        else
          render json: @product_mapping.errors
        end
      end

      # DELETE /product_mappings/1
      # DELETE /product_mappings/1.json
      def destroy
        @product_mapping.destroy

        render json: { notice: 'Product mapping was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_mapping
          @product_mapping = ProductMapping.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_mapping_params
          parameters_set = params.permit(:product_category_id, :extra_fields)
          parameters_set[:extra_fields] = JSON.parse(
            parameters_set[:extra_fields]) if parameters_set[:extra_fields].present?
          parameters_set
        end

        def render_success
          render json: {
            status: 'success',
            data: @product_mapping
          }
        end
    end
  end
end
