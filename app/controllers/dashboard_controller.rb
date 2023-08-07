# app/controllers/home_controller.rb
class DashboardController < ApplicationController
  def index
    @product_categories = ProductCategory.all
    @active_sliders = PrioritySlider.all
    @product_sub_categories = ProductSubCategory.where(parent_id: nil)
    @all_product_sub_categories = ProductSubCategory.all
  end
end