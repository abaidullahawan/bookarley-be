# frozen_string_literal: true

module Api
  module V1
    # City api controller
    class CitiesController < ApplicationController
      # before_action :authenticate_api_v1_user!, except: %i[all_cities destroy]
      before_action :set_city, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      def index
        @q = City.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @cities = pagy(@q.result.order('cities.title': :asc), items: no_of_record)
      end

      def export_csv_and_pdf
        @cities = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'cities/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'cities.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'cities.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = City.column_names
            csv << headers
            @cities.each do |city|
              csv << city.as_json.values_at(*headers)
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
        if @city
          render :show
        else
          render json: @city.errors
        end
      end

      def new
        @city = City.new
      end

      def edit; end

      def create
        @city = City.new(city_params)

        if @city.save
          render json: @city
        else
          render json: @city.errors
        end
      end

      def update
        if @city.update(city_params)
          render json: @city
        else
          render json: @city.errors
        end
      end

      def destroy
        @city.destroy

        render json: { notice: 'City was successfully removed.' }
      end

      def all_cities
        @q = City.ransack(city_type_eq: params[:city_type])
        @list_cities = @q.result.order('cities.title': :asc)
        render json: {
          status: 'success',
          data: @list_cities
        }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_city
          @city = City.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def city_params
          params.require(:city).permit(:id, :title, :comments, :status, :active_image, :city_type, :created_at, :updated_at)
        end
    end
  end
end
