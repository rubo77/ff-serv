class AddCoordsToNodeRegistration < ActiveRecord::Migration
  def self.up
    add_column :node_registrations, :latitude, :float
    add_column :node_registrations, :longitude, :float
  end

  def self.down
    remove_column :node_registrations, :longitude
    remove_column :node_registrations, :latitude
  end
end
