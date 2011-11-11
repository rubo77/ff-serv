class CreateTincs < ActiveRecord::Migration
  def self.up
    create_table :tincs do |t|
      t.integer :node_id
      t.datetime :approved_at
      t.string :approved_by
      t.text :cert_data

      t.timestamps
    end
  end

  def self.down
    drop_table :tincs
  end
end
