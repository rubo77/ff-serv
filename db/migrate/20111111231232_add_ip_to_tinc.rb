class AddIpToTinc < ActiveRecord::Migration
  def self.up
    add_column :tincs, :rip, :string
  end

  def self.down
    remove_column :tincs, :rip
  end
end
