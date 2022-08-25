# frozen_string_literal: true

# Loading resources and building PDF and CSV url
module Products
  extend ActiveSupport::Concern

  def favourite_products_for_user(data)
    @data.map { |data|
      (data.active_images.attached? && data.cover_photo.attached?) ? data.as_json.merge(
        active_images_path: data.active_images.map { |img| url_for(img) }).as_json.merge(
          cover_photo_path: url_for(
            data.cover_photo)) : data.active_images.attached? ? data.as_json.merge(
              active_images_path: data.active_images.map { |img| url_for(
                img) }) : data.cover_photo.attached? ? data.as_json.merge(
                  cover_photo_path: url_for(data.cover_photo)) : data.as_json
    }
  end

  def active_images_for_products(products)
    @products.map { |product|
      (product.active_images.attached? && product.cover_photo.attached?) ? product.as_json({no: 'no favourite attribute'}).merge(
        active_images_path: product.active_images.map { |img| url_for(img) }).as_json({no: 'no assocaited object'}).merge(
          cover_photo_path: url_for(
            product.cover_photo)) : product.active_images.attached? ? product.as_json({no: 'no favourite attribute'}).merge(
              active_images_path: product.active_images.map { |img| url_for(
                img) }) : product.cover_photo.attached? ? product.as_json({no: 'no favourite attribute'}).merge(
                  cover_photo_path: url_for(product.cover_photo)) : product.as_json({no: 'no favourite attribute'})
    }
  end

  def active_images_for_show(product)
    (@product.active_images.attached? && @product.cover_photo.attached?) ?
              @product.as_json({no: 'no favourite attribute'}).merge(
                active_images_path: @product.active_images.map { |img| url_for(img) }).as_json({no: 'no favourite attribute'}).merge(
                  cover_photo_path: url_for(@product.cover_photo)) : @product.active_images.attached? ?
                    @product.as_json({no: 'no favourite attribute'}).merge(active_images_path: @product.active_images.map {
                    |img| url_for(img) }) : @product.cover_photo.attached? ? @product.as_json({no: 'no favourite attribute'}).merge(
                        cover_photo_path: url_for(@product.cover_photo)) : @product.as_json({no: 'no favourite attribute'})
  end
end
