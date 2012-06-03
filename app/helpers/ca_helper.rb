module CaHelper

  ##Easy-RSA-Stuff
  def self.easy_rsa_ca_cert(*args,&block)
    @@cert ||= File.read(ca_config['key_path']+"/ca.crt")
  end
  
  #CA-Methods
  #See: http://seattlerb.rubyforge.org/quick_cert/QuickCert.html for details
  #Since no "good" openssl api doc is available, we follow that class.
  
  ## Generate a new OpenSSL keypair
  def openssl_generate_key(*args,&block)
    keypair = OpenSSL::PKey::RSA.new CaHelper.ca_config['key_size']
  end
  
  ## Generate a OpenSSL CSR
  def openssl_create_csr(*args,&block)
    key = args[0][:key]
    name = OpenSSL::X509::Name.new [['CN', "To be detailed"]]
    req = OpenSSL::X509::Request.new
    req.version = 0
    req.subject = name
    req.public_key = key.public_key
    req.sign key, OpenSSL::Digest::SHA1.new
    req
  end
  
  ##Extract serial from certificate 
  def openssl_serial(cert)
    cert = OpenSSL::X509::Certificate.new(cert)
    cert.serial
  end
  
  ##Generate a crl using given certs.
  def self.openssl_gencrl(certs)
    #How to generate a crl? Docs??? However, there is a test-helper in ruby (core)
    #It's called: crl = issue_crl([], 1, now, now+1600, [],cert, @rsa2048, OpenSSL::Digest::SHA1.new)
    
    #cert = issue_cert(@ca, @rsa2048, 1, now, now+3600, [],nil, nil, OpenSSL::Digest::SHA1.new)
    #@rsa2048 = OpenSSL::TestUtils::TEST_KEY_RSA2048
    
    
    #From ruby-1.9.2-p290/test/openssl/utils.rb
    #def issue_crl(revoke_info, serial, lastup, nextup, extensions,
    #                issuer, issuer_key, digest)
    #    crl = OpenSSL::X509::CRL.new
    #    crl.issuer = issuer.subject
    #    crl.version = 1
    #    crl.last_update = lastup
    #    crl.next_update = nextup
    #    revoke_info.each{|rserial, time, reason_code|
    #      revoked = OpenSSL::X509::Revoked.new
    #      revoked.serial = rserial
    #      revoked.time = time
    #      enum = OpenSSL::ASN1::Enumerated(reason_code)
    #      ext = OpenSSL::X509::Extension.new("CRLReason", enum)
    #      revoked.add_extension(ext)
    #      crl.add_revoked(revoked)
    #    }
    #    ef = OpenSSL::X509::ExtensionFactory.new
    #    ef.issuer_certificate = issuer
    #    ef.crl = crl
    #    crlnum = OpenSSL::ASN1::Integer(serial)
    #    crl.add_extension(OpenSSL::X509::Extension.new("crlNumber", crlnum))
    #    extensions.each{|oid, value, critical|
    #      crl.add_extension(ef.create_extension(oid, value, critical))
    #    }
    #    crl.sign(issuer_key, digest)
    #    crl
    #  end

    crl = OpenSSL::X509::CRL.new #Generate empty crl
    crl.issuer = ca_cert.subject
    crl.version = 1
    crl.last_update = Time.now
    crl.next_update = Time.now + 60 #Next Update in a minute
    certs.each do |cert_data|
      cert =  OpenSSL::X509::Certificate.new(cert_data)
      revoked = OpenSSL::X509::Revoked.new
      puts "cert.serial is #{cert.serial} \n"
      revoked.serial = cert.serial
      revoked.time = Time.now
      enum = OpenSSL::ASN1::Enumerated(7) #privilegeWithdrawn - see: http://www.ipa.go.jp/security/rfc/RFC3280-04EN.html#412051
      ext = OpenSSL::X509::Extension.new("CRLReason", enum) 
      revoked.add_extension(ext)
      crl.add_revoked(revoked)
    end
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.issuer_certificate = ca_cert
    ef.crl = crl
    crlnum = OpenSSL::ASN1::Integer(Time.now.to_i)
    crl.add_extension(OpenSSL::X509::Extension.new("crlNumber", crlnum))
    crl.sign(ca_key, OpenSSL::Digest::SHA1.new)
    crl
  end
  
  ##Sign a CSR
  def openssl_sign_csr(csr,cn)
    #Read CA Data
    name = OpenSSL::X509::Name.new [['CN', cn]]
    ca = CaHelper.ca_cert
    ca_keypair = CaHelper.ca_key
    generated_serial = ""
    File.open(CaHelper.ca_config['key_path']+"/serial",File::RDWR) do |f|
      f.flock(File::LOCK_EX)
      generated_serial = f.read.chomp.hex
      f.rewind
      f << "%04X" % (generated_serial + 1)
      f.flush
      f.flock(File::LOCK_UN)
    end
    #Build new certificate
    cert = OpenSSL::X509::Certificate.new
    from = Time.now
    cert.subject = name
    cert.issuer = ca.subject
    cert.not_before = from
    cert.not_after = from + 365 * 10 * 24 * 60 * 60 #10 years
    cert.public_key = csr.public_key
    cert.serial = generated_serial
    cert.version = 2 # X509v3
    #Type is client
    #Cert attributes
    basic_constraint = "CA:FALSE"
    key_usage = ["nonRepudiation","digitalSignature","keyEncipherment"]
    ext_key_usage = ["clientAuth"]
    
    #Write cert attributes as extensions
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = ca
    ex = []
    ex << ef.create_extension("basicConstraints", basic_constraint, true)
    ex << ef.create_extension("nsComment",
                              "Freifunk-KBU/Ruby/OpenSSL Generated Certificate")
    ex << ef.create_extension("subjectKeyIdentifier", "hash")
    ex << ef.create_extension("nsCertType", "client")
    ex << ef.create_extension("keyUsage", key_usage.join(","))
    ex << ef.create_extension("extendedKeyUsage", ext_key_usage.join(","))
    cert.extensions = ex
    cert.sign ca_keypair, OpenSSL::Digest::SHA1.new
    cert
  end
  
  
  private
  def self.ca_config
    @@ca_config ||= YAML::load_file("#{Rails.root}/config/ssl.yml")[RAILS_ENV]
  end
  def self.easy_rsa_ca_key(*args,&block)
    @@key ||= File.read(ca_config['key_path']+"/ca.key")
  end
  
  def self.ca_cert
    @@ca_cert ||= OpenSSL::X509::Certificate.new easy_rsa_ca_cert
  end
  
  def self.ca_key
    @@ca_key ||= OpenSSL::PKey::RSA.new easy_rsa_ca_key
  end
    
end
