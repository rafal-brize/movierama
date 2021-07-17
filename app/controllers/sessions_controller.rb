class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    UserRegistration.new(auth_hash).tap do |ur|
      authenticate! ur.user

      if ur.created?
        flash[:notice] = "Account created"
      else
        flash[:notice] = "Welcome back"
      end
    end
    redirect_to root_url
  end

  def destroy
    logout!
    redirect_to root_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
