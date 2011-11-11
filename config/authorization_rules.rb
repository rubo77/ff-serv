authorization do
  role :admin do
    has_permission_on :users, :to => [:update,:edit,:index]
    has_permission_on :tincs, :to => [:approve]
  end
end
