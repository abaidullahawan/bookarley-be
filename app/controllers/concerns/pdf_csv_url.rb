# frozen_string_literal: true

# Loading resources and building PDF and CSV url
module PdfCsvUrl
  extend ActiveSupport::Concern

  def get_url(save_path)
    @url = 'http://localhost:4000/uploads/'
    @url = 'https://portal.tractoronline.com.pk/uploads/' if Rails.env.production?
    @save_path = @url + save_path.to_s.split('/').last
  end
end
