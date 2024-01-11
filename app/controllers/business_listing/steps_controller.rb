module BusinessListing
  class StepsController < StoreController
    respond_to :html
    def step1; end

    def process_step1
      cookies[:category_id] = params[:product][:category_id]
      redirect_to business_listing_step2_path
    end

    def step2
      redirect_to business_listing_step3_path if spree_current_user.present?
    end

    def process_step2
      redirect_to business_listing_step3_path
    end

    def step3
    end

    def process_step3
      cookies[:business_details] = params[:business][:owner_name]
      cookies[:business_email] = params[:business][:email]
      cookies[:business_phone] = params[:business][:phone]
      cookies[:business_city] = params[:business][:city]
      redirect_to business_listing_step4_path
    end

    def step4
    end

    def process_step4
      cookies[:product_info] = params[:product][:name]
      cookies[:product_sub_category] = params[:product][:sub_category]
      cookies[:product_down_payment] = params[:product][:down_payment]
      cookies[:product_down_payment_type] = params[:product][:down_payment_type]
      cookies[:product_cancellation_policy] = params[:product][:cancellation_policy]
      redirect_to business_listing_step5_path
    end

    def step5
    end

    def process_step5
      cookies[:product_capacity] = params[:product][:capacity]
      cookies[:product_description] = params[:product][:description]
      redirect_to business_listing_step6_path
    end

    def step6
      @business_category = cookies[:category_id]
      @business_details = cookies[:business_details]
      @product_info = cookies[:product_info]
    end

    def save_business_listing
      business = Business.create(owner_name: cookies[:business_details])
      business.save

      ActiveRecord::Base.transaction do
        product = Spree::Product.new(name: cookies[:product_info], description: [:product_description])
        # master_variant = Spree::Variant.new(is_master: true)
        # product.master = master_variant
        product.save!
        ActiveRecord::Base.transaction.commit
      end


      cookies.delete(:category_id)
      cookies.delete(:business_details)
      cookies.delete(:business_email)
      cookies.delete(:business_phone)
      cookies.delete(:business_city)
      cookies.delete(:product_info)

      redirect_to business_listing_step6_path
    end

    def confirmation
    end

    private

    def business_params
      params.permit(:owner_name, :brand_name, :email, :phone, :website, :city, :sub_category, :expertise, :amenties, :description)
    end

    def product_params
      params.permit(:name, :description, images: [])
    end
  end
end
