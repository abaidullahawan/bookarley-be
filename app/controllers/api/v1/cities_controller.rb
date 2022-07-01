# frozen_string_literal: true

module Api
  module V1
    # City api controller
    class CitiesController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[all_cities]
      before_action :set_city, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /cities
      # GET /cities.json
      def index
        @q = City.includes(active_image_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @cities = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @cities.map { |city|
            city.active_image.attached? ? city.as_json.merge(
              active_image_path: url_for(city.active_image)) : city.as_json
            },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @cities = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'cities/index.pdf.erb', encoding: 'UTF-8'
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

      # GET /cities/1
      # GET /cities/1.json
      def show
        if @city
          render json: {
            status: 'success',
            data: @city.active_image.attached? ? @city.as_json.merge(
              active_image_path: url_for(@city.active_image)) : @city.as_json
            }
        else
          render json: @city.errors
        end
      end

      # GET /cities/new
      def new
        @city = City.new
      end

      # GET /cities/1/edit
      def edit; end

      # POST /city
      # POST /city.json
      def create
        @city = City.new(city_params)

        if @city.save
          render_success
        else
          render json: @city.errors
        end
      end

      # PATCH/PUT /cities/1
      # PATCH/PUT /cities/1.json
      def update
        if @city.update(city_params)
          render_success
        else
          render json: @city.errors
        end
      end

      # DELETE /cities/1
      # DELETE /cities/1.json
      def destroy
        @city.destroy

        render json: { notice: 'City was successfully removed.' }
      end

      def all_cities
        @q = City.ransack(city_type_eq: params[:city_type])
        @list_cities = @q.result
        render json: {
          status: 'success',
          data: @list_cities
        }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_city
          @city = City.includes(:active_image_attachment).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def city_params
          params.permit(:title, :comments, :status, :active_image, :city_type)
        end

        def render_success
          render json: {
            status: 'success',
            data: @city
          }
        end
    end
  end
end
