class AddUsers < ActiveRecord::Migration
  def self.up
    Role.find_or_create_by_name("admin")
    Role.find_or_create_by_name("user")
    Role.find_or_create_by_name("node")
    lhr = Role.find_or_create_by_name("localhost")
    lhu = User.find_or_create_by_email("localhost")
    lhu.update_attribute(:role_id,lhr.id)
  end

  def self.down
  end
end
