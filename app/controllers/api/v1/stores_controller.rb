# frozen_string_literal: true

module Api
  module V1
    class StoresController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[all_stores]
      before_action :set_store, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      def index
        @q = Store.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @stores = pagy(@q.result.order('stores.title': :asc), items: no_of_record)
        render json: {
          status: 'success',
          data: @stores,
          pagination: @pagy
        }
      end

      # def export_csv_and_pdf
      #   @stores = @q.result
      #   path = Rails.root.join('public/uploads')
      #   if params[:format].eql? 'pdf'
      #     file = render_to_string pdf: 'some_file_name',
      #       template: 'stores/index.pdf.erb', encoding: 'UTF-8'
      #     @save_path = Rails.root.join(path, 'stores.pdf')
      #     File.open(@save_path, 'wb') do |f|
      #       f << file
      #     end
      #   else
      #     @save_path = Rails.root.join(path, 'stores.csv')
      #     CSV.open(@save_path, 'wb') do |csv|
      #       headers = City.column_names
      #       csv << headers
      #       @stores.each do |city|
      #         csv << city.as_json.values_at(*headers)
      #       end
      #     end
      #   end
      #   get_url(@save_path)
      #   render json: {
      #     status: 'success',
      #     file_path: @save_path
      #   }
      # end

      def show
        if @store
          render json: {
            status: 'success',
            data: @store
            }
        else
          render json: @store.errors
        end
      end

      def new
        @store = Store.new
      end

      def edit; end

      def create
        @store = Store.new(store_params)

        if @store.save
          render_success
        else
          render json: @store.errors
        end
      end

      def update
        if @store.update(store_params)
          render_success
        else
          render json: @store.errors
        end
      end

      def destroy
        @store.destroy

        render json: { notice: 'Store was successfully removed.' }
      end

      def all_stores
        @q = Store.ransack(city_type_eq: params[:city_type])
        @list_stores = @q.result.order('stores.title': :asc)
        render json: {
          status: 'success',
          data: @list_stores
        }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_store
          @store = Store.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def store_params
          params.permit(:title, :description, :status, :user_id, :profile_image, :cover_image)
        end

        def render_success
          render json: {
            status: 'success',
            data: @store
          }
        end
    end
  end
end
