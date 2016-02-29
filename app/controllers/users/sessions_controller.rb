class Users::SessionsController < Devise::SessionsController
  TRUE_REGEX = /true/i
  SAML_REGEX = /^(saml|cas)$/i
  # override so that database_authenticatable can be removed
  def new_session_path(_scope)
    new_user_session_path
  end

  def omniauth_provider_key
    @omniauth_provider_key ||= Rails.application.class.cas_configuration_opts[:provider]
  end

  def omniauth_opts
    @omniauth_opts ||= Rails.application.class.cas_configuration_opts
  end

  # updates the search counter (allows the show view to paginate)
  def update
    if params[:counter] && session[:search][:counter] != params[:counter]
      session[:search][:counter] = params[:counter]
    end

    if params[:id]
      redirect_to action: "show", controller: :catalog, id: params[:id]
    else
      redirect_to action: "index", controller: :catalog
    end
  end

  def after_sign_out_path_for(_resource)
    service = root_url
    if omniauth_provider_key =~ SAML_REGEX
      strategy = OmniAuth::Strategies::SAML.new(Rails.application, omniauth_opts)
      service = strategy.logout_url(root_url)
    end
    service
  end

  protected

    def auth_hash
      request.env.fetch(Cul::Omniauth::Callbacks::OMNIAUTH_REQUEST_KEY, {})
    end
end
