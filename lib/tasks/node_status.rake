### IMPORTANT: IT IS ASSUMED THAT 'node' IS PARSED AS A COMMAND LINE PARAMETER - CORRECTLY ESCAPED!
### MAKE SURE, THAT VALID NODE MACS ARE ACCEPPTED, ONLY -> see: ApplicationController::authenticate_mac

task :node_up,[:argument,:node] => :environment do |task, args|
  status = Status.where(:name => "up").first
  update_node_status(ARGV,status)
end

task :node_down,  [:argument] => :environment do |task, args|
  status = Status.where(:name => "down").first
  update_node_status(ARGV,status)
end

private
def update_node_status(argv,status)
  node_str = argv[1].split('=').last
  ip_addr = argv[2].split('=').last if argv[2].present?
  node = Node.where(:wlan_mac => node_str).first
  node.update_attributes({
      :status_id => status.id,
      :current_ip => ip_addr
  })
end
