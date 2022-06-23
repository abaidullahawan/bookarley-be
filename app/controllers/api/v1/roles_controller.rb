# frozen_string_literal: true

module Api
  module V1
    # Role api controller
    class RolesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_role, only: %i[show edit update destroy]
      require 'tempfile'
      require 'csv'

      # GET /roles
      # GET /roles.json
      def index
        @q = Role.ransack(params[:q])
        return export_csv_and_pdf if params[:format].present?

        no_of_record = params[:no_of_record] || 10
        @pagy, @roles = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @roles,
          pagination: @pagy
        }
      end

      def export_csv_and_pdf
        @roles = @q.result
        path = Rails.root.join('public/uploads')
        if params[:format].eql? 'pdf'
          file = render_to_string pdf: 'some_file_name', template: 'roles/index.pdf.erb', encoding: 'UTF-8'
          @save_path = Rails.root.join(path, 'roles.pdf')
          File.open(@save_path, 'wb') do |f|
            f << file
          end
        else
          @save_path = Rails.root.join(path, 'roles.csv')
          CSV.open(@save_path, 'wb') do |csv|
            headers = Role.column_names
            csv << headers
            @roles.each do |role|
              csv << role.as_json.values_at(*headers)
            end
          end
        end
        render json: {
          status: 'success',
          file_path: @save_path
        }
      end

      # GET /roles/1
      # GET /roles/1.json
      def show
        if @role
          render_success
        else
          render json: @role.errors
        end
      end

      # GET /roles/new
      def new
        @role = Role.new
      end

      # GET /roles/1/edit
      def edit; end

      # POST /role
      # POST /role.json
      def create
        @role = Role.new(role_params)

        if @role.save
          render_success
        else
          render json: @role.errors
        end
      end

      # PATCH/PUT /roles/1
      # PATCH/PUT /roles/1.json
      def update
        if @role.update(role_params)
          render_success
        else
          render json: @role.errors
        end
      end

      # DELETE /roles/1
      # DELETE /roles/1.json
      def destroy
        @role.destroy

        render json: { notice: 'Role was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_role
          @role = Role.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def role_params
          params.require(:role).permit(:name, :resource_type, :resource_id)
        end

        def render_success
          render json: {
            status: 'success',
            data: @role
          }
        end
    end
  end
end
