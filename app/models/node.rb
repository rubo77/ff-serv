class Node < ActiveRecord::Base
  using_access_control
  has_many :certs
  has_many :prefix_delegation
  has_many :tincs
  belongs_to :status
    
  ## All nodes, where: VPN-Status is up, or tinc is trying to connect  
  def self.registerable(remote_addr)
    n = Node.new # Use for quering ACL-Data
    if(n.permitted_to? :register_all)
      Node.all_unregistered
    else
      running_nodes = Node.where(:status_id => Status.up, :user_id => nil, :current_ip => remote_addr)
      connecting_nodes = (Node.unregistred.keep_if {|n| n.current_ip == remote_addr}) || []
      running_nodes + connecting_nodes
    end
  end
  
  def self.all_unregistered
    running_nodes = Node.where(:user_id => nil) || []
  end

  def current_status
    self.status || Status.find_by_name("down")
  end
  
  def current_ip
    permitted_to! :show_ip
    ip = read_attribute :current_ip
    logger.info "IP is #{ip}"
    return ip
  end

  def to_s
    "#{wlan_mac}"
  end

  
  private
  def self.unregistred(historic = false)
    nodes = {}
    t45_secs_ago = Time.now - 45
    logfile = Tinc.config['logfile']
    # May 26 22:40:03 felix tinc.intracity[28545]: Error while processing ID from b0487a96f582 (84.63.38.123 port 42756)
    IO.popen("#{logfile}") do |pipe|
      pipe.each_line do |line|
        md = line.match '(.+) .+ tinc..+\[\d+\]: Error while processing ID from (.+) \((.+) port \d+\)'
        if(md)
          time_stmp = md[1]
          node_mac = md[2]
          node_ip = md[3]
          md2 = time_stmp.match '(\w+) (\d\d) (\d\d):(\d\d):(\d\d)'
          yet = Time.local(t45_secs_ago.year, md2[1], md2[2],md2[3],md2[4],md2[5])
          # Since tinc tries to connect every 45secs, we will use data younger than 45secs only
          ago = yet - t45_secs_ago #If ago > 0 => Time > t45_secs_ago => Recent enough
          if(ago > 0 || historic) # If recent enough or historic nodes should be included ...
            nodes[node_mac] = Node.new(:wlan_mac => node_mac, :bat0_mac => node_mac, :current_ip => node_ip, :updated_at => DateTime.parse(yet.to_s))
          end
        end
      end
    end
    return nodes.values
  end

end
