class NodeRegistration < ActiveRecord::Base
  using_access_control
  validates_uniqueness_of :node_id, :message => "Ein Node darf nur einmal registriert werden"
  belongs_to :node
  belongs_to :user
  before_create :set_user
  attr_accessible :node_name, :node_id, :operator_name, :contact_mail, :standort, :latitude, :longitude, :notice

  # Change possible: New one and create allowd
  # Or: Old one and update allowed
  def can_change?
    (new_record?) ? permitted_to?(:create) : permitted_to?(:update)
  end
  
  # For simplicity: Only Nodes of new registrations can be changed
  # A node-Registration is tightly bound to a single node.
  def can_change_node?
    new_record?
  end
  
  def set_user
    self.user_id = Authorization.current_user.id
  end

end
