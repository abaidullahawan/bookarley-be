# app/controllers/product_sub_categories_controller.rb

class ProductSubCategoriesController < ApplicationController
  before_action :set_product_sub_category, only: [:show, :edit, :update, :destroy]

  def index
    @product_sub_categories = ProductSubCategory.all
  end

  def show
  end

  def new
    @product_sub_category = ProductSubCategory.new
  end

  def create
    @product_sub_category = ProductSubCategory.new(product_sub_category_params)

    respond_to do |format|
      if @product_sub_category.save
        format.html do
          flash[:success] = "Product sub category was successfully created."
          redirect_to '/dashboard#sub_categories'
        end
      else
        redirect_to '/dashboard#sub_categories'
      end
    end
  end

  def edit
    @product_sub_category = ProductSubCategory.find(params[:id])
    respond_to do |format|
      if @product_sub_category.save
        format.html do
          flash[:success] = "Product sub category was successfully updated."
          redirect_to '/dashboard#sub_categories'
        end
      else
        redirect_to '/dashboard#sub_categories'
      end
    end
  end
  

  def update
    if @product_sub_category.update(product_sub_category_params)
      redirect_to '/dashboard#sub_categories', notice: 'Product sub-category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product_sub_category.destroy
    respond_to do |format|
      format.html { redirect_to '/dashboard#sub_categories', notice: 'Product sub category was successfully deleted.' }
      format.json { render json: { status: "success" } }
    end
  end


  private

  def set_product_sub_category
    @product_sub_category = ProductSubCategory.find(params[:id])
  end

  def product_sub_category_params
    params.permit(:title, :description, :status, :icon, :link, :product_category_id, :parent_id, :active_image)
  end
end
