class Cert < ActiveRecord::Base
  belongs_to :node
  attr_accessor :cert_key
  include CaHelper
  
  def self.create_by_node(node)
    cert = Cert.new(:node => node)
    cert.create_x509_and_key
    cert.save!
    cert
  end
  
  def create_x509_and_key
    cert_cn = "#{node.wlan_mac} - #{node.bat0_mac}"
    self.cert_key = openssl_generate_key
    logger.debug "\nCert is: #{self.inspect}\n"
    logger.debug "\nNode is: #{self.node.inspect}\n"
    csr = openssl_create_csr(:key => self.cert_key)
    cert = openssl_sign_csr(csr,cert_cn)
    self.cert_data = cert.to_pem
    self.fingerprint = Digest::MD5.hexdigest(cert.to_der) 
  end
  
  def serial
    serial = openssl_serial(self.cert_data).to_s(16) if self.cert_data
    return "0x#{serial}"
  end
  
  def self.ca_cert
    return CaHelper.easy_rsa_ca_cert
  end
  
  def self.ca_crl
    certs = Cert.where(:revoked => true).collect {|c| c.cert_data}
    CaHelper.openssl_gencrl(certs)
  end
  
  def revoke
    self.revoked = true
    self.revoked_at = DateTime.now
  end
end
