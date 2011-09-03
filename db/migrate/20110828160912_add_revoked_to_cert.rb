class AddRevokedToCert < ActiveRecord::Migration
  def self.up
    add_column :certs, :revoked, :boolean
  end

  def self.down
    remove_column :certs, :revoked
  end
end
