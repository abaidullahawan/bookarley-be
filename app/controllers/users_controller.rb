# frozen_string_literal: true

class UsersController < StoreController
  skip_before_action :set_current_order, only: :show, raise: false
  prepend_before_action :authorize_actions, only: :new

  include Taxonomies

  def show
    load_object
    @orders = @user.orders.complete.order('completed_at desc')
  end

  def create
    @user = Spree::User.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def edit
    load_object
  end

  def update
    @user = Spree::User.find(params[:id])
    if @user.update(user_params)
      if !@user.has_spree_role?('admin')
        @role_update = Spree::Role.where("name ILIKE ?", "%seller%").first
  
          if @role_update
            @user_role_update = Spree::RoleUser.find_or_initialize_by(user_id: @user.id)
            @user_role_update.role_id = @role_update.id
            @user_role_update.save
          end
      end


      spree_current_user.reload
      redirect_url = account_url

      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        if Spree::Auth::Config[:signout_after_password_change]
          redirect_url = login_url
        else
          bypass_sign_in(@user)
        end
      end
      redirect_to seller_information_path, notice: I18n.t('spree.account_updated')
    else
      render :edit
    end
  end

  def seller_information
    @user = spree_current_user    
  end

  private

  def user_params
  params.require(:user).permit(Spree::PermittedAttributes.user_attributes | [:email, :full_name, :date_of_birth, :gender, :profile, :location, :contact_information, :bio])
  end

  def load_object
    @user ||= Spree::User.find_by(id: spree_current_user&.id)
    # authorize! params[:action].to_sym, @user
  end

  def authorize_actions
    authorize! params[:action].to_sym, Spree::User.new
  end

  def accurate_title
    I18n.t('spree.my_account')
  end
end
