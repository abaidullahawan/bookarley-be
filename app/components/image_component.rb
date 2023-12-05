# frozen_string_literal: true

class ImageComponent < ViewComponent::Base
  attr_reader :image, :size, :classes, :options

  def initialize(local_assigns = {})
    @image = local_assigns.delete(:image)
    @size = local_assigns.delete(:size) { :mini }
    @classes = local_assigns.delete(:classes)
    @options = local_assigns
  end

  def call
    ActiveStorage::Current.host = request.host_with_port
    if image
      image_extension = File.extname(image.filename.to_s).downcase

      if image_extension == '.jfif'
        content_tag :div, nil, class: ['image-placeholder', size].join(' ')
      else
        image_tag image.attachment.url, default_options.merge(options)
      end
    else
      content_tag :div, nil, class: ['image-placeholder', size].join(' ')
    end
  end

  private

  def default_options
    { alt: 'image', class: classes }
  end
end
