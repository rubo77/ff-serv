task :copy_keys,  [:argument] => :environment do |task, args|
  tinc_dir = "/etc/tinc/intracity/hosts/"
  @files = Dir.entries(tinc_dir)
  
  Tinc.find(:all, :joins => [:node], :conditions => ["approved_by is not null and nodes.wlan_mac not in (?)",@files]).each do |tinc|
    File.open("#{tinc_dir}/#{tinc.node.wlan_mac}", 'w') {|f| f.write(tinc.cert_data) }
  end

end