class CreateNodeRegistrations < ActiveRecord::Migration
  def self.up
    create_table :node_registrations do |t|
      t.string :name
      t.integer :node_id
      t.integer :user_id
      t.string :standort
      t.string :contact_mail
      t.text :notice

      t.timestamps
    end
  end

  def self.down
    drop_table :node_registrations
  end
end
