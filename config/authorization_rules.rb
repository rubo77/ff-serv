authorization do
  role :admin do
    has_permission_on :users, :to => [:update,:edit,:index]
    has_permission_on :tincs, :to => [:approve]
    has_permission_on :nodes, :to => [:manage,:show_ip]
  end
  role :user do
    has_permission_on :nodes, :to => [:index]
  end
end
