# frozen_string_literal: true

class UserRegistrationsController < Devise::RegistrationsController
  before_action :check_permissions, only: [:edit, :update]
  skip_before_action :require_no_authentication
  before_action :redirect_logged_in_users, only: [:new]


  def create
    build_resource(spree_user_params)
    resource.otp_code = generate_pin
    resource.otp_generated_at = DateTime.now
    resource.skip_confirmation! if resource.phone_number.present?
    if resource.save
      return redirect_to otp_path(resource_id: resource.id)
      # resource.confirm
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

  def otp
    if params[:resource_id]
      @user = Spree::User.find(params[:resource_id])
    else
      redirect_to root_path
    end
  end

  def otp_verification
    @user = Spree::User.find_by_id(params[:user_id])
    if @user.otp_code.eql?(params[:otp_values])
      @user.confirm
      flash[:notice] = 'You have successfully verified your account and now you can login.'
      redirect_to login_path
    else
      flash[:alert] = 'Pin is incorrect'
      redirect_to otp_path(resource_id: params[:user_id])
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
    params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes | [:email, :phone_number])
  end

  def redirect_logged_in_users
    return unless spree_current_user.present?

    flash[:notice] = 'You are already signed in.'
    redirect_to root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, [:phone_number])
  end

  def generate_pin
    SecureRandom.hex(3).to_s
  end
end
