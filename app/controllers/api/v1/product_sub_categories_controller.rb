# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductSubCategoriesController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[index destroy get_subcategories]
      before_action :set_product_sub_category, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product_sub_categories
      # GET /product_sub_categories.json
      def index
        # Fetch all product sub categories
        @q = ProductSubCategory.includes(:product_category, active_image_attachment: :blob).ransack(params[:q])
        
        # Fetch parent product sub categories
        @parent_product_sub_categories = ProductSubCategory.where(parent_id: nil)

        # Your existing code for rendering JSON response
        return export_csv_and_pdf if params[:format].present?
        no_of_record = params[:no_of_record] || 10
        @pagy, @product_sub_categories = pagy(@q.result.order('product_sub_categories.updated_at': :desc), items: no_of_record)
        render json: {
          status: 'success',
          data: @product_sub_categories.map { |psc|
            psc.active_image.attached? ? JSON.parse(psc.to_json(include: [:product_category])).merge(active_image_path: url_for(psc.active_image)) : JSON.parse(psc.to_json(include: [:product_category]))
          },
          parent_product_sub_categories: @parent_product_sub_categories,  # Add this line to include parent product sub categories in the JSON response
          pagination: @pagy
        }
      end

      def get_subcategories
        product_category_id = params[:product_category_id]
        @product_sub_categories = ProductSubCategory.where(product_category_id: product_category_id)
        hierarchical_sub_categories = build_subcategory_hierarchy(nil, @product_sub_categories)
        render json: hierarchical_sub_categories, status: :ok
      end


      def export_csv_and_pdf
        @product_sub_categories = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'product_sub_categories/index.pdf.erb', encoding: 'UTF-8'
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
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /product_sub_categories/1
      # GET /product_sub_categories/1.json
      def show
        if @product_sub_category
          render json: {
            status: 'success',
            data: @product_sub_category.active_image.attached? ? JSON.parse(
              @product_sub_category.to_json(include: [:product_category])).merge(
                active_image_path: url_for(@product_sub_category.active_image)) : JSON.parse(
                  @product_sub_category.to_json(include: [:product_category]))
          }
        else
          render json: @product_sub_category.errors
        end
      end

      # GET /product_sub_categories/new
      def new
        @product_sub_category = ProductSubCategory.new
      end
      
      def parent_product_sub_categories
        @parent_product_sub_categories = ProductSubCategory.where(parent_id: nil)
  
        render json: {
          status: 'success',
          parent_product_sub_categories: @parent_product_sub_categories
        }
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
          @product_sub_category = ProductSubCategory.joins(:product_category).includes(
            :product_category).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_sub_category_params
          params.permit(:title, :active_image, :description, :status,
                                                       :product_category_id, :link, :icon, :parent_id)
        end

        def build_subcategory_hierarchy(parent_id, subcategories)
          subcategories.select { |subcategory| subcategory.parent_id == parent_id }.map do |subcategory|
            {
              id: subcategory.id,
              title: subcategory.title,
              subcategories: build_subcategory_hierarchy(subcategory.id, subcategories)
            }
          end
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
