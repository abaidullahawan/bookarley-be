# frozen_string_literal: true

class TaxonsController < StoreController
  helper 'spree/taxons', 'spree/products', 'taxon_filters'

  before_action :load_taxon, only: [:show]

  respond_to :html

  def show
    @products = @taxon.products.includes(:variants_including_master, :taxons)

    respond_to do |format|
      format.html
    end
  end

  private

  def load_taxon
    @taxon = Spree::Taxon.find_by!(permalink: params[:id])
  end

  def accurate_title
    if @taxon
      @taxon.seo_title
    else
      super
    end
  end
end
