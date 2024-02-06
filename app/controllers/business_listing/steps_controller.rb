module BusinessListing
  class StepsController < StoreController
    respond_to :html
    def step1
      session.delete(:category_id) if !params[:back].present?
    end

    def process_step1
      session[:category_id] = params[:product][:category_id]
      redirect_to business_listing_step2_path
    end

    def step2
      redirect_to business_listing_step3_path if spree_current_user.present?
    end

    def process_step2
      redirect_to business_listing_step3_path
    end

    def step3
      @taxons = Spree::Taxonomy.find_by_id(session[:category_id])&.taxons
    end

    def process_step3
      session[:business_owner_name] = params[:business][:owner_name]
      session[:business_email] = params[:business][:email]
      session[:business_phone] = params[:business][:phone]
      session[:business_city] = params[:business][:city]
      session[:business_brand_name] = params[:business][:brand_name]
      redirect_to business_listing_step4_path
    end

    def step4
      @taxons = Spree::Taxonomy.find_by_id(session[:category_id])&.taxons
      @extra_fields = Spree::Property.where(field_type: 'Details')
    end

    def process_step4
      session[:product_name] = params[:product][:name]
      session[:product_address] = params[:product][:address]
      session[:product_pin_point] = params[:product][:pin_point]
      session[:product_sub_category_id] = params[:product][:sub_category_id]
      session[:product_description] = params[:product][:description]
      session[:extra_fields] = params[:extra_fields]
      redirect_to business_listing_step5_path
    end

    def step5
      @extra_fields = Spree::Property.where(field_type: 'Pricing')
    end

    def process_step5
      @business = Business.create(owner_name: session[:business_owner_name],
                                  brand_name: session[:business_brand_name],
                                  email: session[:business_email],
                                  phone: session[:business_phone],
                                  city: session[:business_city])
      @product = Spree::Product.create(name: session[:product_name],
                                       address: session[:product_address],
                                       pin_point: session[:product_pin_point],
                                       description: session[:product_description],
                                       business_id: @business.id, price: params[:product][:package_price],
                                       shipping_category_id: 1)
      uploaded_files = params[:product][:images]

      uploaded_files.each_with_index do |file, index|
        if file.present?
          image = Spree::Image.new(viewable_type: 'Spree::Variant',
                                   viewable_id: @product&.variants_including_master&.first&.id,
                                   type: 'Spree::Image', position: index)
          image.attachment.attach(file)
          image.save
        end
      end
      Spree::Classification.create(product_id: @product.id, taxon_id: session[:product_sub_category_id])
      session[:extra_fields]&.each_with_index do |ef, index|
        Spree::ProductProperty.create(value: ef['value'], property_id: ef['id'], position: index, product_id: @product.id)
      end
      params[:extra_fields]&.each_with_index do |ef, index|
        Spree::ProductProperty.create(value: ef['value'], property_id: ef['id'], position: index, product_id: @product.id, price_id: @product&.prices&.first&.id)
      end
      destroy_sessions
      redirect_to business_listing_step6_path(resource: @product.id)
    end

    def step6
      @product = Spree::Product.find_by_id(params[:resource])
    end

    def save_business_listing
      business = Business.create(owner_name: session[:business_details])
      business.save

      ActiveRecord::Base.transaction do
        product = Spree::Product.new(name: session[:product_info], description: [:product_description])
        product.save!
        ActiveRecord::Base.transaction.commit
      end
      redirect_to business_listing_step6_path
    end

    def confirmation; end

    private

    def destroy_sessions
      session.delete(:business_owner_name)
      session.delete(:business_email)
      session.delete(:business_phone)
      session.delete(:business_city)
      session.delete(:business_brand_name)
      session.delete(:product_name)
      session.delete(:product_address)
      session.delete(:product_pin_point)
      session.delete(:product_sub_category_id)
      session.delete(:product_description)
      session.delete(:extra_fields)
      session.delete(:category_id)
    end

    def product_params
      params.permit(:owner_name, :brand_name, :email, :phone, :website, :city, :sub_category, :expertise, :amenties, :description)
    end

    def business_params
      params.require(:business).permit(:owner_name, :email, :phone, :city, :brand_name)
    end
  end
end
