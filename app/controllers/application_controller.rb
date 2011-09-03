class ApplicationController < ActionController::Base
  
  #Authenticate for Node-based-Request:
  #User: Mac of wlan module
  #Password: Mac of first wired nic (eg eth0)
  private
  def authenticate_mac
    authenticate_or_request_with_http_basic do |username, password|
        logger.error "Node login: #{username} #{password}"
        #Regular expression matches for HW-addresses stolen and modified from http://www.perlmonks.org/?node_id=83405
        session[:wlan_mac] = username
        session[:bat0_mac] = password
        username.match(/^([0-9a-f]{2}(-|$)){6}$/i) && password.match(/^([0-9a-f]{2}(-|$)){6}$/i)
      end
  end  
end