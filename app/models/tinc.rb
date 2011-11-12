class Tinc < ActiveRecord::Base
  require 'digest/sha1'
  belongs_to :node
  validates_presence_of :cert_data
  validates_presence_of :node
  validates_uniqueness_of :cert_data
  after_create :notify_admins
  
  def checksum
    data = Digest::SHA1.hexdigest cert_data
    str = data.scan(/.{1,4}/).join(':')
    str
  end
  
  def notify_admins
    User.joins(:role).where(:roles =>{:name =>"admin"}).each do |admin|
      NotifyMailer.tinc_submit(admin,self).deliver
    end
  end
end
