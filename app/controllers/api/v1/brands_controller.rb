# frozen_string_literal: true

module Api
  module V1
    # Brand api controller
    class BrandsController < ApplicationController
      before_action :set_brand, only: %i[show edit update destroy]

      # GET /brands
      # GET /brands.json
      def index
        @brands = Brand.all.order(name: :asc)
        render json: @brands
      end

      # GET /brands/1
      # GET /brands/1.json
      def show
        if @brand
          render json: @brand
        else
          render json: @brand.errors
        end
      end

      # GET /brands/new
      def new
        @brand = Brand.new
      end

      # GET /brands/1/edit
      def edit; end

      # POST /brands
      # POST /brands.json
      def create
        @brand = Brand.new(brand_params)

        if @brand.save
          render json: @brand
        else
          render json: @brand.errors
        end
      end

      # PATCH/PUT /brands/1
      # PATCH/PUT /brands/1.json
      def update
        respond_to do |format|
          if @brand.update(brand_params)
            format.html { redirect_to @brand, notice: 'brand was successfully updated.' }
            format.json { render :show, status: :ok, location: @brand }
          else
            format.html { render :edit }
            format.json { render json: @brand.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /brands/1
      # DELETE /brands/1.json
      def destroy
        @brand.destroy

        render json: { notice: 'brand was successfully removed.' }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_brand
        @brand = Brand.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def brand_params
        params.permit(:name, :country, :description)
      end
    end
  end
end
