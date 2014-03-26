class Admin::SessionsController < Devise::SessionsController

  layout false

  def auth
    Rails.logger.debug request.env["omniauth.auth"]
    redirect_to checks_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end