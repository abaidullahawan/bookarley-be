# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @product_categories = ProductCategory.all
    @active_sliders = PrioritySlider.all
    @product_sub_categories = ProductSubCategory.all
  end
end