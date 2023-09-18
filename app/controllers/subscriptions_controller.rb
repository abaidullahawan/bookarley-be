# frozen_string_literal: true
require 'ransack'

class SubscriptionsController < StoreController
  respond_to :html

  def index
    @q = Subscription.ransack(params[:q])
    @subscriptions = @q.result(distinct: true)
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      redirect_to root_path, notice: 'Thank you for subscribing.'
    else
      render :new
    end
  end


  private

  def subscription_params
    params.permit(:email)
  end
end
