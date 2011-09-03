class Node < ActiveRecord::Base
  has_many :certs
  has_many :prefix_delegation
end
