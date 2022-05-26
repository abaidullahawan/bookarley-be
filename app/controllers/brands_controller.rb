# frozen_string_literal: true

class BeersController < ApplicationController
  before_action :set_beer, only: %i[show edit update destroy]

  def index; end
end
