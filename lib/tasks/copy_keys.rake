task :copy_keys, :needs => :environment do |task, args|
  tinc_dir_mask = "/etc/tinc/intracity/hosts/*"
  @files = Dir.glob(tinc_dir_mask)
  
  Tinc.find(:all, :joins => [:nodes], :conditions => ["approved_by is not null and node.wlan_mac not in (?)",@files]).each do |tinc|
    File.open(tinc.wlan_mac, 'w') {|f| f.write(tinc.cert_data) }
  end

end