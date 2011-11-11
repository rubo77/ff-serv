class Node < ActiveRecord::Base
  has_many :certs
  has_many :prefix_delegation
  has_many :tincs
end
