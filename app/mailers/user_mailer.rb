# frozen_string_literal: true

class UserMailer < Spree::BaseMailer
  def reset_password_instructions(user, token, *_args)
    @store = Spree::Store.default
    hostname = Rails.env.development? ? 'localhost' : 'bookarley.com'
    @edit_password_reset_url = edit_spree_user_password_url(reset_password_token: token, host: hostname)
    mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])}"
  end

  def confirmation_instructions(user, token, _opts = {})
    @store = Spree::Store.default
    hostname = Rails.env.development? ? 'localhost' : 'bookarley.com'
    @confirmation_url = spree_user_confirmation_url(confirmation_token: token, host: hostname)
    if user.email.present?
      mail to: user.email, from: from_address(@store), subject: "#{@store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions])}"
    end
  end
end
