class CertsController < ApplicationController
  before_filter :authenticate_mac, :only => :ap_cert
  
  #TODO: Revoke nur fuer admins.
  
  # GET /certs
  # GET /certs.xml
  def index
    @certs = Cert.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @certs }
    end
  end
  def show
    @cert = Cert.find(params[:id])
    respond_to do |format|
      format.pem { render :text => @cert.cert_data }
      format.txt { render :text => @cert.cert_data }
    end
  end
  def revoke
    cert = Cert.find(params[:id])
    cert.revoke
    cert.save
    redirect_to certs_path 
  end

  # DELETE /certs/1
  # DELETE /certs/1.xml
  #def destroy
  #  @cert = Cert.find(params[:id])
  #  @cert.destroy#

  #  respond_to do |format|
  #    format.html { redirect_to(certs_url) }
  #    format.xml  { head :ok }
  #  end
  #end
  
  ## GET /certs/ap_cert
  def ap_cert
    respond_to do |format|
      #.key has to be called first ... it generates a certificate
      #This is done for security reasons: Keys are not stored ... thus they have to be retrieved first.
      node = Node.find_or_create_by_wlan_mac_and_bat0_mac(session[:wlan_mac],session[:bat0_mac])
      cert = Cert.create_by_node(node)
      node.certs << cert
      node.save
      format.key { render :text => cert.cert_key.to_pem}
      #.pem can be called later on ... it sends a certificate
      format.pem do
        if node.certs.size > 0
          render :text => node.certs.last.cert_data
        else
          render :status => 404, :text => "Please download ap_cert.key first - it'll create your certificate"
        end
      end
    end
    
  end
  
  ## GET /certs/ca_cert.pem
  def ca_cert
    render :text => Cert.ca_cert
  end
  
  ## GET /certs/dh1024.pem
  def dh1024
    render :text => OpenSSL::PKey::DH.generate(1024).to_pem
  end
  
  def crl
    render :text => Cert.ca_crl.to_pem
  end
    
end
