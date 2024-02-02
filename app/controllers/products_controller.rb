# frozen_string_literal: true

class ProductsController < StoreController
  before_action :load_product, only: :show
  before_action :load_taxon, only: [:index, :favourite_products]

  helper 'spree/products', 'spree/taxons', 'taxon_filters'

  respond_to :html

  rescue_from Spree::Config.searcher_class::InvalidOptions do |error|
    raise ActionController::BadRequest.new, error.message
  end

  def index
    @q = Spree::Product.where(is_approved: true).ransack(params[:q])
    @products = @q.result.page(params[:page]).per(50)
  end

  def show
    @variants = @product.
      variants_including_master.
      display_includes.
      with_prices(current_pricing_options).
      includes([:option_values, :images])

    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
  end

  def add_to_favorites
    product = Spree::Product.find(params[:id])
    favorite = Favorite.create(user_id: spree_current_user.id, product_id: product.id)
    if favorite
      render turbo_stream: turbo_stream.replace(
        "add-to-favorites-link-#{product.id}", partial: 'products/remove_from_favroite_partial', locals: { product: product }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "add-to-favorites-link-#{product.id}", partial: 'products/remove_from_favroite_partial', locals: { product: product }
      )
    end
  end

  def remove_from_favorites
    product = Spree::Product.find(params[:id])
    favorite = Favorite.find_by(user_id: spree_current_user.id, product_id: product.id)
    if favorite.destroy
      render turbo_stream: turbo_stream.replace(
        "remove-from-favorites-link-#{product.id}", partial: 'products/add_to_favroite_partial', locals: { product: product }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "remove-from-favorites-link-#{product.id}", partial: 'products/add_to_favroite_partial', locals: { product: product }
      )
    end
  end

  def favourite_products
    @user_favorites = Favorite.where(user_id: spree_current_user.id)
    @favourite_products = Spree::Product.where(id: @user_favorites.pluck(:product_id))
  end


  private

  def accurate_title
    if @product
      @product.meta_title.blank? ? @product.name : @product.meta_title
    else
      super
    end
  end

  def load_product
    if spree_current_user.try(:has_spree_role?, "admin")
      @products = Spree::Product.with_discarded
    else
      @products = Spree::Product.all

    end
    @product = @products.friendly.find(params[:id])
  end

  def load_taxon
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end
end
