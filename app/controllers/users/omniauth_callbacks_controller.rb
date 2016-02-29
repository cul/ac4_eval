class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Cul::Omniauth::Callbacks
  skip_before_action :verify_authenticity_token
  def developer
    current_user ||= User.find_or_create_by(email: request.env["omniauth.auth"][:uid])

    sign_in_and_redirect current_user, event: :authentication
  end

  def affils(user, affils)
    affiliations(user, affils)
  end

  def affiliations(user, affils)
    # NOOP
  end

  def after_sign_out_path_for(resource_name)
    session['logout_redirect_url'] || super
  end
end
