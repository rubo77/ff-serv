class AddRoleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :role_id, :integer
    Role.new(:name => "admin").save!
    Role.new(:name => "benutzer").save!
  end

  def self.down
    remove_column :users, :role_id
  end
end
