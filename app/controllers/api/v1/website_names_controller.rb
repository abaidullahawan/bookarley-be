# frozen_string_literal: true

class Api::V1::WebsiteNamesController < ApplicationController
  def index
    @website_names = WebsiteName.all
    render json: {
      status: 'success',
      data: @website_names
    }
  end
end
