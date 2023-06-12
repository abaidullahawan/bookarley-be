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
        @q = UsersRole.joins(:role, :user).includes(:role, user: :personal_detail).ransack(params[:q])
        @pagy, @user_roles = pagy(@q.result.order('users_roles.updated_at': :desc), items: no_of_record)
      end

      def show
        if @users_role
          render :show
        else
          render json: @users_role.errors
        end
      end

      def new
        @users_role = UsersRole.new
      end

      def edit; end

      def create
        @users_role = UsersRole.new(users_roles_params)

        if @users_role.save
          render :show
        else
          render json: @users_role.errors
        end
      end

      def update
        if @users_role.update(users_roles_params)
          render :show
        else
          render json: @users_role.errors
        end
      end

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
    end
  end
end
