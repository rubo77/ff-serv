class AddWlanMacToNodes < ActiveRecord::Migration
  def self.up
    add_column :nodes, :wlan_mac, :string
  end

  def self.down
    remove_column :nodes, :wlan_mac
  end
end
