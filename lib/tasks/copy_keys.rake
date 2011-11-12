task :copy_keys,  [:argument] => :environment do |task, args|
  TINC_DIR = "/etc/tinc/intracity/hosts/"
  @files = Dir.entries(TINC_DIR)
  Tinc.find(:all, :joins => [:node], :conditions => ["approved_by is not null and nodes.wlan_mac not in (?)",@files]).each do |tinc|
    File.open("#{TINC_DIR}/#{tinc.node.wlan_mac}", 'w') {|f| f.write(tinc.cert_data) }
  end
end

