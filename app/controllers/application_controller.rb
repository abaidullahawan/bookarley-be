# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update, keys: [
      :name, :nickname, personal_detail_attributes: [
        :id, :first_name, :last_name, :gender, :dob, :country, :city
        ]
      ]
    )
  end
end
