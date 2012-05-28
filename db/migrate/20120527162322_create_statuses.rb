class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name

      t.timestamps
    end
    Status.new(:name => "up").save!
    Status.new(:name => "down").save!
  end

  def self.down
    drop_table :statuses
  end
end
