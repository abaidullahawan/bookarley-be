# frozen_string_literal: true

module Api
  module V1
    # City api controller
    class CitiesController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[index]
      before_action :set_city, only: %i[show edit update destroy]

      # GET /cities
      # GET /cities.json
      def index
        no_of_record = params[:no_of_record] || 10
        @q = City.ransack(params[:q])
        @pagy, @cities = pagy(@q.result, items: no_of_record)
        render json: {
          status: 'success',
          data: @cities,
          pagination: @pagy
        }
      end

      # GET /cities/1
      # GET /cities/1.json
      def show
        if @city
          render_success
        else
          render json: @city.errors
        end
      end

      # GET /cities/new
      def new
        @city = City.new
      end

      # GET /cities/1/edit
      def edit; end

      # POST /city
      # POST /city.json
      def create
        @city = City.new(city_params)

        if @city.save
          render_success
        else
          render json: @city.errors
        end
      end

      # PATCH/PUT /cities/1
      # PATCH/PUT /cities/1.json
      def update
        if @city.update(city_params)
          render_success
        else
          render json: @city.errors
        end
      end

      # DELETE /cities/1
      # DELETE /cities/1.json
      def destroy
        @city.destroy

        render json: { notice: 'City was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_city
          @city = City.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def city_params
          params.require(:city).permit(:name, :comments)
        end

        def render_success
          render json: {
            status: 'success',
            data: @city
          }
        end
    end
  end
end
