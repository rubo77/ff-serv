class AddCurrentIpToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :current_ip, :string
  end

  def self.down
    remove_column :nodes, :current_ip
  end
end
