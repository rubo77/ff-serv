class PrefixDelegation < ActiveRecord::Base
  belongs_to :node
  def self.delegate_next_prefix
    PrefixDelegation p = PrefixDelegation.create
    v4_base = PrefixDelegation.prefix_config["v4_base"]
    v6_base = PrefixDelegation.prefix_config["v6_base"]
  end
  
  def self.prefix_config
    @@prefix_config ||= YAML::load_file("#{RAILS_ROOT}/config/prefixes.yml")[RAILS_ENV]
    
  end

end
