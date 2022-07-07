# frozen_string_literal: true

module Api
  module V1
    # Model api controller
    class ModelsController < ApplicationController
      #before_action :authenticate_api_v1_user!
      before_action :set_model, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /models
      # GET /models.json
      def index
        @q = Model.includes(:product, active_image_attachment: :blob).ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @models = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @models.map { |model|
            model.active_image.attached? ? JSON.parse(model.to_json(include: [:product])).merge(
              active_image_path: url_for(model.active_image)) : JSON.parse(model.to_json(include: [:product]))
          },
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @models = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'models/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'models.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'models.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Model.column_names
            csv << headers
            @models.each do |model|
              csv << model.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /models/1
      # GET /models/1.json
      def show
        if @model
          render json: {
            status: 'success',
            data: @model.active_image.attached? ? @model.as_json.merge(
              active_image_path: url_for(@model.active_image)) : @model.as_json
            }
        else
          render json: @model.errors
        end
      end

      # GET /models/new
      def new
        @model = Model.new
      end

      # GET /models/1/edit
      def edit; end

      # POST /model
      # POST /model.json
      def create
        @model = Model.new(model_params)

        if @model.save
          render_success
        else
          render json: @model.errors
        end
      end

      # PATCH/PUT /models/1
      # PATCH/PUT /models/1.json
      def update
        if @model.update(model_params)
          render_success
        else
          render json: @model.errors
        end
      end

      # DELETE /models/1
      # DELETE /models/1.json
      def destroy
        @model.destroy

        render json: { notice: 'model was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_model
          @model = Model.includes(:active_image_attachment).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def model_params
          params.permit(:title, :description, :status, :link, :icon, :product_id, :active_image)
        end

        def render_success
          render json: {
            status: 'success',
            data: @model
          }
        end
    end
  end
end