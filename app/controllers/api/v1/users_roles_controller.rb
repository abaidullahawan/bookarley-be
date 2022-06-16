# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class UsersRolesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_user_role, only: %i[show edit update destroy]

      # GET /users_roles
      # GET /users_roles.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = UsersRole.ransack(params[:q])
        @pagy, @user_roles = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @user_roles
        }
      end

      # GET /users_roles/1
      # GET /users_roles/1.json
      def show
        if @users_role
          render_success
        else
          render json: @users_role.errors
        end
      end

      # GET /users_roles/new
      def new
        @users_role = UsersRole.new
      end

      # GET /users_roles/1/edit
      def edit; end

      # POST /users_role
      # POST /users_role.json
      def create
        @users_role = UsersRole.new(users_roles_params)

        if @users_role.save
          render_success
        else
          render json: @users_role.errors
        end
      end

      # PATCH/PUT /users_roles/1
      # PATCH/PUT /users_roles/1.json
      def update
        respond_to do |format|
          if @users_role.update(users_roles_params)
            format.html { redirect_to api_v1_users_role_path(@users_role),
              notice: 'User Role was successfully updated.' }
            format.json { render :show, status: :ok, location: @users_role }
          else
            format.html { render :edit }
            format.json { render json: @users_role.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /users_roles/1
      # DELETE /users_roles/1.json
      def destroy
        @users_role.destroy

        render json: { notice: 'User Role was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user_role
          @users_role = UsersRole.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def users_roles_params
          params.permit(:user_id, :role_id)
        end

        def render_success
          render json: {
            status: 'success',
            data: @users_role
          }
        end
    end
  end
end
