# frozen_string_literal: true

class HomeController < StoreController
  helper 'spree/products'
  respond_to :html

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
  end

  def about_us; end

  def services; end

  def term_of_services; end

  def privacy_policy; end

  def flash_sale; end
end
