# frozen_string_literal: true

module Api
  module V1
    # Product Catories api controller
    class ProductCategoriesController < ApplicationController    
      # before_action :authenticate_api_v1_user!, except: %i[categories_list]
      before_action :set_product_category, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /product categories
      # GET /product_categories.json
      def index
        @q = ProductCategory.includes(:brands, active_image_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @product_categories = pagy(@q.result.order('product_categories.position': :asc),
          items: no_of_record)
        render json: {
          status: 'success',
          data: @product_categories.map { |pc|
            products_with_image = pc.products.map { |product|
              product_hash = product.as_json(only: [:id, :title, :description, :price])
              product_hash['active_image_path'] = url_for(product.active_image) if product.active_image.attached?
              product_hash
            }
            pc.active_image.attached? ? JSON.parse(pc.to_json(include: [:brands])).merge(
              active_image_path: url_for(pc.active_image),
              products: products_with_image
            ) : JSON.parse(pc.to_json(include: [:brands])).merge(
              products: products_with_image
            )
          },
          pagination: @pagy
        }
      end

      def view_more
        @product_category = ProductCategory.find(params[:id])
        @products = @product_category.products
        render json: {
          status: 'success',
          data: @products
        }
      end

      def find_product_sub_categories
        @product_category = ProductCategory.find(params[:id])
        @product_sub_categories = @product_category.product_sub_categories
        render json: {
          status: 'success',
          data: @product_sub_categories.map { |sc| sc.as_json(only: [:id, :title]) }
        }
      end

      def export_csv_and_pdf
        @product_categories = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'product_categories/index.pdf.erb', encoding: 'UTF-8'
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
          render json: {
            status: 'success',
            data: @product_category.active_image.attached? ? @product_category.as_json.merge(
              active_image_path: url_for(
                @product_category.active_image)) : @product_category.as_json
          }
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
          create_brand_category
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
        params[:is_option] = nil if params[:is_option].eql? 'nil'
        @q = ProductCategory.order(position: :asc).includes(:brands, :product_sub_categories,
          active_image_attachment: :blob).ransack(is_option_eq: params[:is_option])
        @categories_list = @q.result
        render json: {
          status: 'success',
          data: @categories_list.map { |cl|
            cl.active_image.attached? ? JSON.parse(cl.to_json(
              include: [:products, :brands, :product_sub_categories ])).merge(active_image_path: url_for(
                cl.active_image)).merge(active_image_thumbnail:
									url_for(cl.active_image.variant(resize_to_limit: [200, 200]).processed)) : JSON.parse(cl.to_json(include: [:products,:brands, :product_sub_categories ]))
          }
        }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product_category
          @product_category = ProductCategory.includes(:active_image_attachment).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_category_params
          params.permit(:id, :title, :active_image, :description, :status, :link, :icon, :is_option, :position)
        end

        def render_success
          render json: {
            status: 'success',
            data: @product_category
          }
        end
        def create_brand_category
          if params[:brand_id].present?
            temp = params[:brand_id].split(',')
            temp.map { |temp| BrandCategory.find_or_create_by(
              brand_id: temp, product_category_id: @product_category.id)}
          end
        end

        def update_brand_category
          if params[:brand_id].present?
            BrandCategory.where(product_category_id: @product_category.id).destroy_all
            temp = params[:brand_id].split(',')
            temp.map { |temp| BrandCategory.find_or_create_by(
              brand_id: temp, product_category_id: @product_category.id)}
          end
        end
    end
  end
end
