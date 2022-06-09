# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class CountriesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_country, only: %i[show edit update destroy]

      # GET /countries
      # GET /countries.json
      def index
        @countries = Country.all
        render json: {
          status: 'success',
          data: @countries
        }
      end

      # GET /countries/1
      # GET /countries/1.json
      def show
        if @country
          render_success
        else
          render json: @country.errors
        end
      end

      # GET /countries/new
      def new
        @country = Country.new
      end

      # GET /countries/1/edit
      def edit; end

      # POST /country
      # POST /country.json
      def create
        @country = Country.new(country_params)

        if @country.save
          render_success
        else
          render json: @country.errors
        end
      end

      # PATCH/PUT /countries/1
      # PATCH/PUT /countries/1.json
      def update
        respond_to do |format|
          if @country.update(country_params)
            format.html { redirect_to api_v1_country_path(@country),
              notice: 'Country was successfully updated.' }
            format.json { render :show, status: :ok, location: @country }
          else
            format.html { render :edit }
            format.json { render json: @country.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /countries/1
      # DELETE /countries/1.json
      def destroy
        @country.destroy

        render json: { notice: 'Country was successfully removed.' }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_country
          @country = Country.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def country_params
          params.require(:country).permit(:name, :comments)
        end

        def render_success
          render json: {
            status: 'success',
            data: @country
          }
        end
    end
  end
end
