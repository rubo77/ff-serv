class Status < ActiveRecord::Base
  def to_s
    "#{name}"
  end

  def self.up
    @@up_status ||= Status.find_by_name("up")
  end
  
  def self.down
    @@down_status ||= Status.find_by_name("down")
  end
end
