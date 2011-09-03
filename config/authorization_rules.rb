authorization do
  role :admin do
    has_permission_on :users, :to => [:update,:edit,:index]
  end
end
