# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductsController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[get_products show]
      before_action :set_product, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl
      include Products
      # GET /products
      # GET /products.json
      def index
        @q = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob,
          cover_photo_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?
        no_of_record = params[:no_of_record] || 10
        @pagy, @products = pagy(@q.result.order('products.updated_at': :desc),
          items: no_of_record)
        render json: {
          status: 'success',
          data: active_images_for_products(@products),
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @products = @q.result.order('products.id': :desc)
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
            data: active_images_for_show(@product),
            profile: @product.user.profile.attached? ? url_for(@product.user.profile) :
              'No profile image'
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
        @product.active_images_attachments.destroy_all unless params[:active_images].blank?
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
        check_null_values
        @q = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob,
          cover_photo_attachment: :blob).ransack(product_type_eq: params[:product_type],
          featured_eq: params[:featured], city_eq: params[:city], price_lt: params[:price_lt],
          price_gt: params[:price_gt], brand_id_eq: params[:brand_id], status_eq: params[:status],
          product_category_id_eq: params[:product_category_id], title_cont: params[:title],
          user_id_eq: params[:user_id])
        no_of_record = params[:no_of_record] || 10
        @pagy, @data = pagy(@q.result, items: no_of_record)
        render json: {
          data: favourite_products_for_user(@data),
          pagination: @pagy
        }
      end

      def favourite_ads
        if params[:user_id].present? && params[:product_id].present?
          favourite_ad = FavouriteAd.find_by(user_id: params[:user_id], product_id: params[:product_id])
          if favourite_ad.present?
            favourite_ad.destroy
            render json: { notice: 'Ad removed from Favourite Ads.' }
          else
            favourite_ad = FavouriteAd.find_or_create_by(user_id: params[:user_id],
              product_id: params[:product_id])
            if favourite_ad.save
              render json: { notice: 'Ad added to Favourite Ads.' }
            else
              render json: favourite_ad.errors
            end
          end
        end
      end

      def favourite_products
        @products = Product.joins(:favourite_ads).includes(:brand, :product_category, active_images_attachments: :blob,
          cover_photo_attachment: :blob).with_favourite_products
          render json: {
            status: 'success',
            data: active_images_for_products(@products)
          }
      end

      def reported_ads
        report_ad = ReportedAd.find_by(user_id: current_api_v1_user.id,
          product_id: params[:product_id])
        if report_ad.present?
          render json: { notice: 'You have already reported this ad' }
        else
          ReportedAd.create(reason: params[:reason], user_id: current_api_v1_user.id,
            product_id: params[:product_id])
          render json: { notice: 'Ad was successfully reported.' }
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.includes(:user, active_images_attachments: :blob,
            cover_photo_attachment: :blob).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def product_params
          parameters_set = params.permit(:title, :description, :status, :cover_photo, :link,
                                         :product_type, :brand_id, :price, :featured,
                                         :product_category_id, :city, :location, :user_id, :phone_no,
                                         :extra_fields, active_images: [])
          parameters_set[:extra_fields] = JSON.parse(
            parameters_set[:extra_fields]) if parameters_set[:extra_fields].present?
          parameters_set
        end

        def render_success
          render json: {
            status: 'success',
          }
        end

        def render_errors
          render json: {
            status: 'error'
          }
        end

        def check_null_values
          params[:product_type] = nil if params[:product_type].eql? 'nil'
          params[:featured] = nil if params[:featured].eql? 'nil'
          params[:price_lt] = nil if params[:price_lt].eql? 'nil'
          params[:price_gt] = nil if params[:price_gt].eql? 'nil'
          params[:city] = nil if params[:city].eql? 'nil'
          params[:title] = nil if params[:title].eql? 'nil'
          params[:brand_id] = nil if params[:brand_id].eql? 'nil'
          params[:status] = nil if params[:status].eql? 'nil'
          params[:product_category_id] = nil if params[:product_category_id].eql? 'nil'
          params[:user_id] = nil if params[:user_id].eql? 'nil'
        end
    end
  end
end
