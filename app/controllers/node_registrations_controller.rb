class NodeRegistrationsController < ApplicationController
  # GET /node_registrations
  # GET /node_registrations.xml
  def index
    @node_registrations = NodeRegistration.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @node_registrations }
    end
  end

  # GET /node_registrations/1
  # GET /node_registrations/1.xml
  def show
    @node_registration = NodeRegistration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @node_registration }
    end
  end

  # GET /node_registrations/new
  # GET /node_registrations/new.xml
  def new
    @node_registration = NodeRegistration.new
    @node_registration.node_id = params[:node]
    @registerable_nodes = Node.registerable(request.remote_ip)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @node_registration }
    end
  end

  # GET /node_registrations/1/edit
  def edit
    @node_registration = NodeRegistration.find(params[:id])
  end

  # POST /node_registrations
  # POST /node_registrations.xml
  def create
    @node_registration = NodeRegistration.new(params[:node_registration])

    respond_to do |format|
      if @node_registration.save
        format.html { redirect_to(@node_registration, :notice => 'Node registration was successfully created.') }
        format.xml  { render :xml => @node_registration, :status => :created, :location => @node_registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @node_registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /node_registrations/1
  # PUT /node_registrations/1.xml
  def update
    @node_registration = NodeRegistration.find(params[:id])

    respond_to do |format|
      if @node_registration.update_attributes(params[:node_registration])
        format.html { redirect_to(@node_registration, :notice => 'Node registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @node_registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /node_registrations/1
  # DELETE /node_registrations/1.xml
  def destroy
    @node_registration = NodeRegistration.find(params[:id])
    @node_registration.destroy

    respond_to do |format|
      format.html { redirect_to(node_registrations_url) }
      format.xml  { head :ok }
    end
  end
  
end
