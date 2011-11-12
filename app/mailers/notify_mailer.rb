class NotifyMailer < ActionMailer::Base
  def self.mail_config
    @@mail_config ||= YAML::load_file("#{RAILS_ROOT}/config/mail.yml")
  end  
  default :from => mail_config["from"]
  
  def tinc_submit(user,tinc)
    @user = user
    @tinc = tinc
    mail(:to => user.email, :subject => "Neuer Tinc-Key eingereicht")
  end

end
