# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class ProductsController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[get_products show get_products_for_landing_page search_products_by_title]
      before_action :set_product, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl
      include Products

      def index
        check_null_values
        # if featured is true or false.All products will be returned in response. and from that response we can check the the value of featured
        if params[:featured] == nil
          # for getting the products that have requested to be featured. means there featured feild value should be nil
          result = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob, cover_photo_attachment: :blob).where(featured: nil)
        else
          @q = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob, cover_photo_attachment: :blob).ransack(params[:q])
          result = @q.result
        end

        return export_csv_and_pdf if params[:format].present?

        req_prods = Product.where(featured: nil).count
        no_of_record = params[:no_of_record] || 10
        @pagy, @products = pagy(result.order('products.updated_at': :desc), items: no_of_record)

        render json: { status: 'success', data: active_images_for_products(@products), pagination: @pagy, req_prods: req_prods }
      end

      def export_csv_and_pdf
        @products = @q.result.order('products.id': :desc)
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
            headers = Product.column_names.excluding('updated_at', 'created_at')
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

      def import_data_form_csv
        is_admin = current_api_v1_user.roles.all.pluck(:name).include?('admin')
        current_user_id = current_api_v1_user.id
        csv_text = File.read(params[:file]).force_encoding('ISO-8859-1').encode('utf-8', replace: nil)
        csv = CSV.parse(csv_text, headers: true)
        products_not_found = []
        issues = {}
        if check_allowed_headers(csv, issues)
          csv.each do |row|
            if row['id'].present?
              @product = Product.find_by(id: row['id'])
              if @product.present?
                if is_admin
                  @product.update(row)
                elsif current_user_id == @product.user_id
                  @product.update(row)
                else
                  products_not_found.push(row['id'])
                end
              else
                products_not_found.push(row['id'])
              end
            end
          end
          issues[:prducts_not_updated] = products_not_found
          render json: { status: 'success', data: issues }
        else
          render json: { status: 'error', data: issues }
        end
      end

      def check_allowed_headers(csv, issues)
        if csv.headers.include?(nil)
          issues[:message] = 'Empty columns are not allowed'
          false
        else
          allowed_headers = ['call_for_price', 'description', 'id', 'location', 'phone_no', 'price', 'title']
          if (csv.headers.sort - allowed_headers).empty?
            true
          else
            issues[:message] = "These columns not allowed #{csv.headers.sort - allowed_headers}"
            false
          end
        end
      end

      def show
        if @product
          user_profile = @product.user.profile.attached? ? url_for(@product.user.profile) : 'No profile image'

          render json: { status: 'success', data: active_images_for_show(@product), profile: user_profile }
        else
          render json: @product.errors
        end
      end

      def new
        @product = Product.new
      end

      def edit
      end

      def create
        custom_brand_create
        @product = Product.new(product_params)
        if @product.save
          render_success
        else
          render json: @product.errors
        end
      end

      def update
        check_null_values
        @product.active_images_attachments.destroy_all unless params[:active_images].blank?
        custom_brand_create

        if @product.update(product_params)
          render_success
        else
          render json: @product.errors
        end
      end

      def destroy
        @product.destroy
        render json: { notice: 'Product was successfully removed.' }
      end

      def get_products
        check_null_values
        @q = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob,
          cover_photo_attachment: :blob).order(updated_at: :desc).ransack(title_or_status_or_description_or_city_or_location_cont:params[:search_string],product_type_eq: params[:product_type],
          featured_eq: params[:featured], city_eq: params[:city], price_lt: params[:price_lt],
          price_gt: params[:price_gt], brand_id_eq: params[:brand_id], status_eq: params[:status],
          product_category_id_eq: params[:product_category_id], title_cont: params[:title],
          user_id_eq: params[:user_id])

        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @data = pagy(@q.result, items: no_of_record)

        render json: { data: favourite_products_for_user(@data), pagination: @pagy }
      end

      def get_products_for_landing_page
        product_limit = 10
        featured_products = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob, cover_photo_attachment: :blob).where('products.featured': true).order('random()')
        unfeatured_products = Product.includes(:user, :brand, :product_category, active_images_attachments: :blob, cover_photo_attachment: :blob).where('products.featured': false).order('random()')
        products = []
        ProductCategory.all.each do |cate|
          tempFeatured = featured_products.where(product_category_id: cate.id)
          tempUnfeature = unfeatured_products.where(product_category_id: cate.id)
          if tempFeatured.count >= product_limit
            products.push(tempFeatured.limit(product_limit))
          elsif tempFeatured.count < product_limit
            products.push(tempFeatured + tempUnfeature.limit(product_limit - tempFeatured.count))
          end
        end

        render json: { data: active_images_of_products_for_landing_page(products) }
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
        @products = Product.joins(:favourite_ads).includes(:brand, :product_category, active_images_attachments: :blob, cover_photo_attachment: :blob).with_favourite_products

        render json: { status: 'success', data: active_images_for_products(@products) }
      end

      def reported_ads
        report_ad = ReportedAd.find_by(user_id: current_api_v1_user.id, product_id: params[:product_id])
        if report_ad.present?
          render json: { notice: 'You have already reported this ad' }
        else
          ReportedAd.create(reason: params[:reason], user_id: current_api_v1_user.id, product_id: params[:product_id])
          render json: { notice: 'Ad was successfully reported.' }
        end
      end

      def search_products_by_title
        @searched_product_by_sku = Product.includes(:brand).ransack('title_or_brand_title_cont': params[:search_value].downcase.to_s).result.limit(20)

        render json: { status: 'success', data: @searched_product_by_sku }
      end

      def getSystemNotifications
        temp1 = Product.where(featured: nil).count
        temp2 = Product.all.count
        temp3 = Product.where(featured: true).count
        temp4 = Product.where(featured: false).count

        render json: {
          status: 'success',
          data: { featured_ads: temp3, featured_requested: temp1, total_ads: temp2, unfeatured_ads: temp4 }
        }
      end

      def all_update
        Product.all.update_all(active_images: product_params[:active_images])
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_product
          @product = Product.includes(:user, active_images_attachments: :blob,
            cover_photo_attachment: :blob).find(params[:id])
        end

        def custom_brand_create
          if params[:custom_brand].present?
            brand = Brand.create(title: params[:custom_brand], is_listed: false)
            params[:brand_id] = brand.id
          end
        end

        # Only allow a list of trusted parameters through.
        def product_params
          parameters_set = params.permit(
            :title, :description, :status, :cover_photo, :driver_photo, :link, :product_type, :brand_id, :price, :featured, :product_category_id, :city, :location, :user_id,
            :phone_no, :price_currency, :call_for_price, :extra_fields, active_images: []
          )
          parameters_set[:extra_fields] = JSON.parse(parameters_set[:extra_fields]) if parameters_set[:extra_fields].present?
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
