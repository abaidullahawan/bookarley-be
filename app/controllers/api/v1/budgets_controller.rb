# frozen_string_literal: true

module Api
  module V1
    # Budget api controller
    class BudgetsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_budget, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'
      include PdfCsvUrl

      # GET /budgets
      # GET /budgets.json
      def index
        @q = Budget.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @budgets = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @budgets,
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @budgets = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name',
            template: 'budgets/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'budgets.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'budgets.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Budget.column_names
            csv << headers
            @budgets.each do |budget|
              csv << budget.as_json.values_at(*headers)
            end
          end
        end
        get_url(@save_path)
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /budgets/1
      # GET /budgets/1.json
      def show
        if @budget
          render json: {
            status: 'success',
            data: @budget
          }
        else
          render json: @budget.errors
        end
      end

      # GET /budgets/new
      def new
        @budget = Budget.new
      end

      # GET /budgets/1/edit
      def edit; end

      # POST /budget
      # POST /budget.json
      def create
        @budget = Budget.new(budget_params)

        if @budget.save
          render_success
        else
          render json: @budget.errors
        end
      end

      # PATCH/PUT /budgets/1
      # PATCH/PUT /budgets/1.json
      def update
        if @budget.update(budget_params)
          render_success
        else
          render json: @budget.errors
        end
      end

      # DELETE /budgets/1
      # DELETE /budgets/1.json
      def destroy
        @budget.destroy

        render json: { notice: 'Budget was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_budget
          @budget = Budget.includes(:active_image_attachment).find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def budget_params
          params.permit(:title, :description, :status, :link, :icon, :active_image)
        end

        def render_success
          render json: {
            status: 'success',
            data: @budget
          }
        end
    end
  end
end
