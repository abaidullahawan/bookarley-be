# frozen_string_literal: true

class Api::V1::AppUsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_app_user, only: %i[show]

  def index
    no_of_record = params[:no_of_record] || 10
    @q = User.includes(:profile_attachment).ransack(params[:q])
    @pagy, @users = pagy(@q.result, items: no_of_record)
    render json: {
      status: 'success',
      data: @users.map { |user|
        user.profile.attached? ? user.as_json(only: %i[id name email username gender]).merge(
          profile_path: url_for(user.profile)) : user.as_json(only: %i[id name email username])
      },
    }
  end


  def show
    if @app_user
      render json: @app_user.to_json(include: [:personal_detail])
    else
      render json: @app_user.errors
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_user
      @app_user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_user_params
      params.require(:user).permit(:name, :id, :email, :password, :password_confirmation,
        personal_detail_attributes: [:id, :first_name, :last_name, :gender, :username,
        :dob, :country, :city])
    end
end
