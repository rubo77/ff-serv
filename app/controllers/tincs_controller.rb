class TincsController < ApplicationController
  before_filter :authenticate_mac, :only => :create
  filter_resource_access  
  
  # GET /tincs
  # GET /tincs.xml
  def index
    @tincs = Tinc.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tincs }
    end
  end


  # POST /tincs
  # POST /tincs.xml
  def create
    data = params[:cert].read
    @tinc = Tinc.new(:cert_data => data)
    #Quick-and-dirty: Using lff wlan_mac = mac-address of eth0
    wlan_mac = session[:wlan_mac]
    bat0_mac = session[:bat0_mac]
    @tinc.node = Node.find_by_wlan_mac(wlan_mac) || Node.new(:wlan_mac => wlan_mac)
    @tinc.rip = request.remote_ip
    respond_to do |format|
      if @tinc.save
        format.txt  {  }
      else
        format.txt { render :text => "Error processing tinc-submission - " + @tinc.errors.full_messages.join("\n")  + "\n"}
      end
    end
  end

  # POST /tincs/1/approve
  def approve
    #Update == approve!
    @tinc = Tinc.find(params[:id])
    @tinc.approved_at = DateTime.now
    @tinc.approved_by = current_user.email
    respond_to do |format|
      if @tinc.save
        format.html { redirect_to(tincs_path, :notice => 'Key akzeptiert') }
      else
        format.html { edirect_to(tincs_path, :notice => "Key konnte nicht akzeptiert werden") }
      end
    end
  end
end
