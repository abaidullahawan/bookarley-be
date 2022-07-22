# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class CountriesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_country, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /countries
      # GET /countries.json
      def index
        @q = Country.includes(active_image_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @countries = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @countries.map { |country|
            country.active_image.attached? ? country.as_json.merge(
              active_image_path: url_for(country.active_image)) : country.as_json
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @countries = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'countries/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'countries.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'countries.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Country.column_names
            csv << headers
            @countries.each do |country|
              csv << country.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /countries/1
      # GET /countries/1.json
      def show
        if @country
          render json: {
            status: 'success',
            data: @country.active_image.attached? ? @country.as_json.merge(
              active_image_path: url_for(@country.active_image)) : @country.as_json
          }
        else
          render json: @country.errors
        end
      end

      # GET /countries/new
      def new
        @country = Country.new
      end

      # GET /countries/1/edit
      def edit; end

      # POST /country
      # POST /country.json
      def create
        @country = Country.new(country_params)

        if @country.save
          render_success
        else
          render json: @country.errors
        end
      end

      # PATCH/PUT /countries/1
      # PATCH/PUT /countries/1.json
      def update
        if @country.update(country_params)
          render_success
        else
          render json: @country.errors
        end
      end

      # DELETE /countries/1
      # DELETE /countries/1.json
      def destroy
        @country.destroy

        render json: { notice: 'Country was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_country
          @country = Country.includes(:active_image_attachment).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def country_params
          params.permit(:title, :comments, :status, :active_image)
        end

        def render_success
          render json: {
            status: 'success',
            data: @country
          }
        end
    end
  end
end
