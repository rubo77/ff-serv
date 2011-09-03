class RemoveWlanMacFromCerts < ActiveRecord::Migration
  def self.up
    remove_column :certs, :wlan_mac
  end

  def self.down
    add_column :certs, :wlan_mac, :string
  end
end
