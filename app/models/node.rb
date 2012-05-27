class Node < ActiveRecord::Base
  has_many :certs
  has_many :prefix_delegation
  has_many :tincs
  belongs_to :status
    
    
  def self.unregistred(historic = false)
    nodes = {}
    t45_secs_ago = Time.now - 60
    logfile = Tinc.config['logfile']
    # May 26 22:40:03 felix tinc.intracity[28545]: Error while processing ID from b0487a96f582 (84.63.38.123 port 42756)
    IO.popen("grep 'Error while processing ID from' #{logfile}") do |pipe|
      pipe.each_line do |line|
        md = line.match '(.+) .+ tinc..+\[\d+\]: Error while processing ID from (.+) \((.+) port \d+\)'
        if(md)
          time_stmp = md[1]
          node_mac = md[2]
          node_ip = md[3]
  
          time_stmp = DateTime.parse(md[1], "%c") # %c => May 26 22:40:03
          # Since tinc tries to connect every 45secs, we will use data younger than 45secs only
          ago = time_stmp.to_time - t45_secs_ago #If ago > 0 => Time > t45_secs_ago => Recent enough
          if(ago > 0 || historic) # If recent enough or historic nodes should be included ...
            nodes[node_mac] = Node.new(:wlan_mac => node_mac, :bat0_mac => node_mac, :current_ip => node_ip, :updated_at => time_stmp)
          end
        end
      end
    end
    return nodes.values
  end

  
end
