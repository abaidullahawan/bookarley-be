# frozen_string_literal: true

module Api
  module V1
    # Role api controller
    class RolesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_role, only: %i[show edit update destroy]

      # GET /roles
      # GET /roles.json
      def index
        @roles = Role.all
        render json: {
          status: 'success',
          data: @roles
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
        respond_to do |format|
          if @role.update(role_params)
            format.html { redirect_to api_v1_role_path(@role),
              notice: 'Role was successfully updated.' }
            format.json { render :show, status: :ok, location: @role }
          else
            format.html { render :edit }
            format.json { render json: @role.errors, status: :unprocessable_entity }
          end
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
