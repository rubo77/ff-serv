class AddNodeIdToCert < ActiveRecord::Migration
  def self.up
    add_column :certs, :node_id, :integer
  end

  def self.down
    remove_column :certs, :node_id
  end
end
