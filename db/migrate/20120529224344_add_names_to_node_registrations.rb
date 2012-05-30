class AddNamesToNodeRegistrations < ActiveRecord::Migration
  def self.up
    add_column :node_registrations, :node_name, :string
    add_column :node_registrations, :operator_name, :string
  end

  def self.down
    remove_column :node_registrations, :operator_name
    remove_column :node_registrations, :node_name
  end
end
