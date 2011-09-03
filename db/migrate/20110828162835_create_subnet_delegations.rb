class CreateSubnetDelegations < ActiveRecord::Migration
  def self.up
    create_table :subnet_delegations do |t|
      t.integer :node_id
      t.string :v4_prefix
      t.string :v6_prefix

      t.timestamps
    end
  end

  def self.down
    drop_table :subnet_delegations
  end
end
