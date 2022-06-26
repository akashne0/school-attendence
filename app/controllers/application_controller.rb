class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  #after signing in to specific page_load
  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end
