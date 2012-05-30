class RemoveNameFromNodeRegistrations < ActiveRecord::Migration
  def self.up
    remove_column :node_registrations, :name
  end

  def self.down
    add_column :node_registrations, :name, :string
  end
end
