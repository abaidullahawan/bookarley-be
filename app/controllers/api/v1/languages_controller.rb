# frozen_string_literal: true

module Api
  module V1
    # Language api controller
    class LanguagesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_language, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /languages
      # GET /languages.json
      def index
        @q = Language.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @languages = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @languages,
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @languages = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'languages/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'languages.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'languages.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Language.column_names
            csv << headers
            @languages.each do |language|
              csv << language.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /languages/1
      # GET /languages/1.json
      def show
        if @language
          render_success
        else
          render json: @language.errors
        end
      end

      # GET /languages/new
      def new
        @city = Language.new
      end

      # GET /languages/1/edit
      def edit; end

      # POST /language
      # POST /language.json
      def create
        @language = Language.new(language_params)

        if @language.save
          render_success
        else
          render json: @language.errors
        end
      end

      # PATCH/PUT /languages/1
      # PATCH/PUT /languages/1.json
      def update
        if @language.update(language_params)
          render_success
        else
          render json: @language.errors
        end
      end

      # DELETE /languages/1
      # DELETE /languages/1.json
      def destroy
        @language.destroy

        render json: { notice: 'Language was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_language
          @language = Language.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def language_params
          params.require(:language).permit(:title, :description, :status)
        end

        def render_success
          render json: {
            status: 'success',
            data: @language
          }
        end
    end
  end
end
