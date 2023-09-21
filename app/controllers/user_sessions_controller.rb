# frozen_string_literal: true

class UserSessionsController < Devise::SessionsController
  # This is included in ControllerHelpers::Order.  We just want to call
  # it after someone has successfully logged in.
  after_action :set_current_order, only: :create

  def create
    if valid_credentials?
      # User provided valid credentials
      authenticate_spree_user!
      
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('spree.logged_in_succesfully')
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        end
        format.js { render success_json }
      end
    else
      # User provided invalid credentials
      respond_to do |format|
        format.html do
          flash.now[:error] = t('devise.failure.invalid')
          flash.now[:error] = t('devise.failure.email_invalid') if invalid_email?
          flash.now[:error] = t('devise.failure.password_invalid') if invalid_password?
          render :new
        end
        format.js do
          render json: { error: t('devise.failure.invalid') },
            status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def translation_scope
    'devise.user_sessions'
  end

  private

  def accurate_title
    I18n.t('spree.login')
  end

  def redirect_back_or_default(default)
    redirect_to(session["spree_user_return_to"] || default)
    session["spree_user_return_to"] = nil
  end

  def success_json
    {
      json: {
        user: spree_current_user,
        ship_address: spree_current_user.ship_address,
        bill_address: spree_current_user.bill_address
      }.to_json
    }
  end

  def valid_credentials?
    spree_user = Spree::User.find_by(email: params[:spree_user][:email])
    spree_user&.valid_password?(params[:spree_user][:password])
  end

  def invalid_email?
    spree_user = Spree::User.find_by(email: params[:spree_user][:email])
    spree_user.nil? || !spree_user.valid_password?(params[:spree_user][:password])
  end

  def invalid_password?
    spree_user = Spree::User.find_by(email: params[:spree_user][:email])
    spree_user.present? && !spree_user.valid_password?(params[:spree_user][:password])
  end
end
