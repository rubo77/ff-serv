class RemoveEth0MacFromNodes < ActiveRecord::Migration
  def self.up
    remove_column :nodes, :eth0_mac
  end

  def self.down
    add_column :nodes, :eth0_mac, :string
  end
end
