# frozen_string_literal: true

class UserRegistrationsController < Devise::RegistrationsController
  before_action :check_permissions, only: [:edit, :update]
  skip_before_action :require_no_authentication
  before_action :redirect_logged_in_users, only: [:new]


  def create
    build_resource(spree_user_params)
    if resource.save
      resource.confirm
      set_flash_message(:notice, :signed_up)
      sign_in(:spree_user, resource)
      session[:spree_user_signup] = true
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      respond_with(resource) do |format|
        format.html { render :new }
      end
    end
  end

  protected

  def translation_scope
    'devise.user_registrations'
  end

  def check_permissions
    authorize!(:create, resource)
  end

  private

  def spree_user_params
    params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes | [:email])
  end

  def redirect_logged_in_users
    if spree_current_user.present?
      flash[:notice] = "You are already signed in."
      redirect_to root_path
    end
  end
end
