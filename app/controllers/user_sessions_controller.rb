# frozen_string_literal: true

class UserSessionsController < Devise::SessionsController
  # This is included in ControllerHelpers::Order.  We just want to call
  # it after someone has successfully logged in.
  after_action :set_current_order, only: :create
  before_action :check_failed_attempts, only: [:create]

  def create
    if valid_credentials?
      # User provided valid credentials
      authenticate_spree_user!
      reset_failed_login_attempts
      if @is_invalid
        respond_to do |format|
          format.html do
            flash[:success] = I18n.t('spree.logged_in_succesfully')
            redirect_back_or_default(after_sign_in_path_for(spree_current_user))
          end
          format.js { render success_json }
        end
      end
    else
      record_failed_login_attempt
      # User provided invalid credentials
      if @is_invalid
        respond_to do |format|
          format.html do
            flash.now[:error] = @flash_error
            # flash.now[:error] = t('devise.failure.email_invalid') if invalid_email?
            # flash.now[:error] = t('devise.failure.password_invalid') if invalid_password?
            render :new
          end
          format.js do
            render json: { error: @flash_error },
                   status: :unprocessable_entity
          end
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
    login_param = sign_in_params[:login].downcase
    spree_user = Spree::User.find_by('lower(email) = ? OR phone_number = ?', login_param, login_param)
    valid_password = spree_user&.valid_password?(sign_in_params[:password])
    if !spree_user.present?
      @flash_error = 'Email or Phone Number not exist in database.'
    elsif !valid_password
      @flash_error = 'Invalid Password'
    end
    valid_password
  end

  def check_failed_attempts
    @is_invalid = true
    user = Spree::User.find_by(email: params[:spree_user][:login]) || Spree::User.find_by(phone_number: params[:spree_user][:login])
    if user && (user.failed_attempts_count.to_i >= 5) && (user.last_login_attempt_at.to_i >= 1.hour.ago.to_i)
      sign_out user
      @is_invalid = false
      remaining_minutes = (((user.last_login_attempt_at+1.hours) - DateTime.current) / 1.minute).to_i
      flash.now[:error] = "Too many failed login attempts. Please try again later after #{remaining_minutes} minutes."
      render :new
    end
  end

  def record_failed_login_attempt
    user = Spree::User.find_by(email: params[:spree_user][:login]) || Spree::User.find_by(phone_number: params[:spree_user][:login])
    if !(user && (user.failed_attempts_count.to_i >= 5) && (user.last_login_attempt_at.to_i >= 1.hour.ago.to_i))
      user.update_columns(last_login_attempt_at: Time.current, failed_attempts_count: user.failed_attempts.to_i+1) if user.present?
    end
  end

  def reset_failed_login_attempts
    user = Spree::User.find_by(email: params[:spree_user][:login]) || Spree::User.find_by(phone_number: params[:spree_user][:login])
    if !(user && (user.failed_attempts_count.to_i >= 5) && (user.last_login_attempt_at.to_i >= 1.hour.ago.to_i))
      user.update_columns(last_login_attempt_at: nil, failed_attempts_count: nil) if user.present?
    end
  end
end
