module Api
  module V1
    # Priority Sliders API controller
    class PrioritySlidersController < ApplicationController
      before_action :authenticate_api_v1_user!, except: %i[index destroy]
      before_action :set_priority_slider, only: %i[show edit update destroy]

      # GET /priority_sliders
      # GET /priority_sliders.json
      def index
        @priority_sliders = PrioritySlider.all.order(:priority)
        render json: {
          status: 'success',
          data: @priority_sliders.map { |ps|
            ps.active_image.attached? ? JSON.parse(ps.to_json).merge(
              active_image_path: url_for(ps.active_image)) : JSON.parse(ps.to_json)
          }
        }
      end

      # GET /priority_sliders/1
      # GET /priority_sliders/1.json
      def show
        if @priority_slider
          render json: {
            status: 'success',
            data: @priority_slider.active_image.attached? ? @priority_slider.as_json.merge(
              active_image_path: url_for(@priority_slider.active_image)) : @priority_slider.as_json
          }
        else
          render json: @priority_slider.errors
        end
      end

      # GET /priority_sliders/new
      def new
        @priority_slider = PrioritySlider.new
      end

      # GET /priority_sliders/1/edit
      def edit; end

      # POST /priority_sliders
      # POST /priority_sliders.json
      def create
        @priority_slider = PrioritySlider.new(priority_slider_params)

        if @priority_slider.save
          render_success
        else
          render json: @priority_slider.errors
        end
      end

      # PATCH/PUT /priority_sliders/1
      # PATCH/PUT /priority_sliders/1.json
      def update
        if @priority_slider.update(priority_slider_params)
          render_success
        else
          render json: @priority_slider.errors
        end
      end

      # DELETE /priority_sliders/1
      # DELETE /priority_sliders/1.json
      def destroy
        @priority_slider.destroy

        render json: { notice: 'Priority Slider was successfully removed.' }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_priority_slider
        @priority_slider = PrioritySlider.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def priority_slider_params
        params.permit(:priority, :url, :active_image)
      end

      def render_success
        render json: {
          status: 'success',
          data: @priority_slider
        }
      end
    end
  end
end
