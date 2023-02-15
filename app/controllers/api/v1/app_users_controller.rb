# frozen_string_literal: true

class Api::V1::AppUsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_app_user, only: %i[show]

  def index
    no_of_record = params[:no_of_record] || 10
    @q = User.includes(profile_attachment: :blob).ransack(params[:q])
    @pagy, @users = pagy(@q.result.order('users.updated_at': :desc), items: no_of_record)
    render json: {
      status: 'success',
      data: @users.map { |user|
        user.profile.attached? ? JSON.parse(user.to_json(include: [:personal_detail, :roles])).merge(
          profile_path: url_for(user.profile)) : JSON.parse(user.to_json(
            include: [:personal_detail, :roles]))
      },
      pagination: @pagy
    }
  end

	def get_verification_requested_users
    no_of_record = params[:no_of_record] || 10
    @q = User.includes(profile_attachment: :blob).where(varified_user: nil).ransack(params[:q])
		req_varified = User.where(varified_user: nil).count
    @pagy, @users = pagy(@q.result.order('users.updated_at': :desc), items: no_of_record)
    render json: {
      status: 'success',
      data: @users.map { |user|
        user.profile.attached? ? JSON.parse(user.to_json(include: [:personal_detail, :roles])).merge(
          profile_path: url_for(user.profile)) : JSON.parse(user.to_json(
            include: [:personal_detail, :roles]))
      },
			req_varified:req_varified,
      pagination: @pagy
    }
  end
	def get_verified_users
    no_of_record = params[:no_of_record] || 10
    @q = User.includes(profile_attachment: :blob).where(varified_user: true).ransack(params[:q])
    @pagy, @users = pagy(@q.result.order('users.updated_at': :desc), items: no_of_record)
    render json: {
      status: 'success',
      data: @users.map { |user|
        user.profile.attached? ? JSON.parse(user.to_json(include: [:personal_detail, :roles])).merge(
          profile_path: url_for(user.profile)) : JSON.parse(user.to_json(
            include: [:personal_detail, :roles]))
      },
      pagination: @pagy
    }
  end

	def update
		if(params[:accountVerified]=='nil')
			User.find_by(id:params[:id]).update(varified_user:nil)
		end
		if(params[:accountVerified]==true)
			User.find_by(id:params[:id]).update(varified_user:true)
		end
	end


  def show
    if @app_user
      render json: {
        status: 'success',
        data: @app_user.profile.attached? ? JSON.parse(@app_user.to_json(
          include: [:personal_detail, :products])).merge(profile_path: url_for(
          @app_user.profile)) : JSON.parse(@app_user.to_json(
            include: [:personal_detail, :products]))
      }
    else
      render json: @app_user.errors
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_user
      @app_user = User.includes(:products, profile_attachment: :blob).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_user_params
      params.require(:user).permit(:name, :id, :email, :password, :password_confirmation,
        personal_detail_attributes: [:id, :first_name, :last_name, :gender, :username,
        :dob, :country, :city])
    end
end
