class RemoveEth0MacFromCerts < ActiveRecord::Migration
  def self.up
    remove_column :certs, :eth0_mac
  end

  def self.down
    add_column :certs, :eth0_mac, :string
  end
end
