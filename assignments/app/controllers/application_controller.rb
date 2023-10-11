class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # rescue_from Net::LDAP::ConnectionRefusedError do |exception|
  #   # print(exception)
  #   # print(current_user)
  #   @u1 = User.find_by_uid(params[:user][:uid])
  #   # @u = User.find(2)
  #
  #   redirect_to after_sign_in_path_for sign_in @u1
  #   # redirect_to examscheduler_index_path
  # end
  protect_from_forgery

  before_action :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:uid, :email, :password, :first_name, :middle_name, :last_name])
  end

  def after_sign_in_path_for(resource)
    if current_user.is_admin?
      examscheduler_admin_path
    else
      examscheduler_index_path
    end
  end
end
