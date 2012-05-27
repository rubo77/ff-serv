class AddStatusIdToNode < ActiveRecord::Migration
  def self.up
    add_column :nodes, :status_id, :integer
  end

  def self.down
    remove_column :nodes, :status_id
  end
end
