class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    omniauth_authorization('facebook')
  end

  def google_oauth2
    omniauth_authorization('google')
  end

  def twitter
    omniauth_authorization('twitter')
  end

  def nk
    omniauth_authorization('nk')
  end

  protected

  def omniauth_authorization(provider)
    logger.info("Omniauth.auth: #{request.env['omniauth.auth']}")

    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "#{provider}") if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end