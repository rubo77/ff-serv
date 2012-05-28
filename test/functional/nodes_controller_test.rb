require 'test_helper'
include Devise::TestHelpers

class NodesControllerTest < ActionController::TestCase
  test 'Update Node Status should work form localhost' do
    # Assert: Fixtures node exists
    assert Node.find_by_wlan_mac('123456789abc')
    @request.remote_addr = '::1'
    put(:update_status, {:ip => "1.2.3.4", :status=>"up", :mac => '123456789abc'})
    assert_response :success
    n = Node.find_by_wlan_mac('123456789abc')
    assert_equal n.status.id, Status.up.id
    assert_equal n.current_ip, '1.2.3.4'
    @request.remote_addr = nil
  end
  
  test 'Update Node Status should not work from remote' do
    assert Node.find_by_wlan_mac('123456789abc')
    @request.remote_addr = '192.168.1.1'
    assert_raise Authorization::NotAuthorized do
     put(:update_status, {:ip => "6.7.8.9", :status=>"up", :mac => '123456789abc'})
   end
   @request.remote_addr = nil
  end
end