# frozen_string_literal: true

module Api
  module V1
    # Language api controller
    class LanguagesController < ApplicationController
      # before_action :authenticate_api_v1_user!, except: %i[index destroy]
      before_action :set_language, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      def index
        @q = Language.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @languages = pagy(@q.result.order('languages.updated_at': :desc), items: no_of_record)
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

      def show
        if @language
          render json: @language
        else
          render json: @language.errors
        end
      end

      def new
        @city = Language.new
      end

      def edit; end

      def create
        @language = Language.new(language_params)

        if @language.save
          render json: @language
        else
          render json: @language.errors
        end
      end

      def update
        if @language.update(language_params)
          render json: @language
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
    end
  end
end
