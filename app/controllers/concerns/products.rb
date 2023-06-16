# frozen_string_literal: true

# Loading resources and building PDF and CSV url
module Products
  extend ActiveSupport::Concern

  def favourite_products_for_user(products)
    products.map do |product|
      product.as_json.merge(attach_images(product))
    end
  end

  def active_images_for_products(products)
    products.map do |product|
      product.as_json.merge(attach_images(product))
    end
  end

  def active_images_for_show(product)
    product.as_json.merge(attach_images(product))
  end

  def active_images_of_products_for_landing_page(products_array)
    products_array.map do |products|
      products.map do |product|
        product.as_json.merge(attach_images(product))
      end
    end
  end

  def attach_images(product)
    images = {}

    if product.active_images.attached?
      images[:active_images_path] = product.active_images.map { |img| url_for(img) }
      images[:active_images_thumbnail] = product.active_images.map { |img| url_for(img.variant(resize_to_limit: [200, 200]).processed) }
    end

    if product.cover_photo.attached?
      images[:cover_photo_path] = url_for(product.cover_photo)
      images[:cover_photo_thumbnail] = url_for(product.cover_photo.variant(resize_to_limit: [200, 200]).processed)
    end

    if images.blank?
      images[:no] = 'No favourite attribute'
    end
    images
  end
end
