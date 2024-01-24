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

  def session_expiry_extend
    if params[:extend].eql?('false')
      session[:ignore_modal] = true
    else
      spree_current_user.update(current_sign_in_at: spree_current_user.current_sign_in_at+30.minutes)
    end
  end
end
