class Cert < ActiveRecord::Base
  attr_accessor :cert_key
  include CaHelper
  
  def self.create_by_wlan_and_lan(wlan_mac,eth0_mac)
    cert = Cert.new(:wlan_mac => wlan_mac, :eth0_mac => eth0_mac)
    cert.create_x509_and_key
    cert.save!
    cert
  end
  
  def create_x509_and_key
    cert_cn = "#{self.wlan_mac} - #{self.eth0_mac}"
    self.cert_key = openssl_generate_key
    csr = openssl_create_csr(:key => self.cert_key)
    cert = openssl_sign_csr(:csr => csr, :cn => cert_cn)
    self.cert_data = cert.to_pem
    self.fingerprint = Digest::MD5.hexdigest(cert.to_der)
  end
  
  def serial
    serial = openssl_serial(self.cert_data).to_s(16)
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
