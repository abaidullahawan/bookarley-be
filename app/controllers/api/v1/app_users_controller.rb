# frozen_string_literal: true

class Api::V1::AppUsersController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_app_user, only: %i[show edit update destroy]

  # GET /users
  # GET /users.json
  def index
    @app_users = User.all
    render json: @app_users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if @app_user
      render json: @app_user.to_json(include: [:personal_detail])
    else
      render json: @app_user.errors
    end
  end

  # GET /users/new
  def new
    @app_user = User.new
  end

  # GET /users/1/edit
  def edit
    render json: @app_user.to_json(include: [:personal_detail])

  end

  # POST /users
  # POST /users.json
  def create
    @app_user = User.new(app_user_params)

    if @app_user.save
      render json: @app_user
    else
      render json: @app_user.errors
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @app_user.update(app_user)
        format.html { redirect_to @app_user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_user }
      else
        format.html { render :edit }
        format.json { render json: @app_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @app_user.destroy

    render json: { notice: 'User was successfully removed.' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_user
      @app_user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_user_params
      params.require(:user).permit(:name, :id, :email, personal_detail_attributes: [:id, :first_name,
        :last_name, :gender, :username, :dob, :country, :city])
    end
end
