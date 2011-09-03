class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.integer :user_id
      t.text :position
      t.text :eth0_mac
      t.text :bat0_mac

      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
