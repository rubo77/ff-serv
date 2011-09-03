class CreatePrefixDelegations < ActiveRecord::Migration
  def self.up
    create_table :prefix_delegations do |t|
      t.integer :node_id
      t.string :v4
      t.string :v6

      t.timestamps
    end
  end

  def self.down
    drop_table :prefix_delegations
  end
end
