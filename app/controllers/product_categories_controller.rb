# app/controllers/product_categories_controller.rb

class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only: [:show, :edit, :update, :destroy]

  def index
    @product_categories = ProductCategory.all
  end

  def show
  end

  def new
    @product_category = ProductCategory.new
  end

  def show_edit
    @product_category = ProductCategory.find(params[:id])
    render json: @product_category
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    respond_to do |format|
      if @product_category.save
        format.html do
          flash[:success] = "Product Category was successfully created."
          redirect_to '/dashboard#categories'
        end
      else
        redirect_to '/dashboard#categories'
      end
    end
  end

  def edit
    @product_category = ProductCategory.find(params[:id])
    respond_to do |format|
      if @product_category.save
        format.html do
          flash[:success] = "Product Category was successfully updated."
          redirect_to '/dashboard#categories'
        end
      else
        redirect_to '/dashboard#categories'
      end
    end
  end
  

  def update
    if @product_category.update(product_category_params)
      redirect_to '/dashboard#categories', notice: 'Product category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product_category.destroy
    respond_to do |format|
      format.html { redirect_to '/dashboard#categories', notice: 'Product category was successfully deleted.' }
      format.json { render json: { status: "success" } }
    end
  end


  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def product_category_params
    params.permit(:title, :description, :status, :icon, :link, :active_image)
  end
end
