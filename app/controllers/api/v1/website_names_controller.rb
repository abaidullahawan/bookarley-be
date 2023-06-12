# frozen_string_literal: true

class Api::V1::WebsiteNamesController < ApplicationController
  def index
    @website_names = WebsiteName.all
  end
end
