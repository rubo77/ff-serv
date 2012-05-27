class RemoveStatusFromNode < ActiveRecord::Migration
  def self.up
    remove_column :nodes, :status
  end

  def self.down
    add_column :nodes, :status, :string
  end
end
