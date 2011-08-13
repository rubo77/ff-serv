class ApplicationController < ActionController::Base
  attr_accessor :current_user
  before_filter :set_current_user
  
  protected
  
  def set_current_user
    current_user = User.find_by_id(session[:user_id])
    Authorization.current_user = current_user
  end
  
end