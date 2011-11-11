class Tinc < ActiveRecord::Base
  require 'digest/sha1'
  belongs_to :node
  validates_presence_of :cert_data
  validates_presence_of :node
  validates_uniqueness_of :cert_data
  def checksum
    data = Digest::SHA1.hexdigest cert_data
    str = data.scan(/.{1,4}/).join(':')
    str
  end
end
