authorization do
  role :admin do
    has_permission_on :users, :to => [:manege,:index]
    has_permission_on :tincs, :to => [:approve,:manege,:index]
    has_permission_on :nodes, :to => [:show_ip,:manage,:index,:read]
  end
  
  # Logged in user
  role :user do
    has_permission_on :nodes, :to => [:index]
  end
  
  role :guest do
    has_permission_on :nodes, :to => [:index]
  end
  
  # Node, authenticated by mac
  role :node do
    # Nodes are allowed to to create nodes on initial registration
    has_permission_on :nodes, :to => [:create]
    
    # Nodes are allowed to update their data
    has_permission_on :nodes do
      to :update,:read
      if_attribute :wlan_mac => is {user.email}
    end
    
    # Nodes are allowed to submit tinc-requests
    has_permission_on :tincs, :to => [:create]
    
  end
  
  # HTTP-RPC-Call by localhost
  role :localhost do
    has_permission_on :nodes, :to => [:show_ip,:update_status,:update,:index]
  end
end
