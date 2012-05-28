require 'test_helper'
class ActionController::TestCase
  include Devise::TestHelpers
end
class TincsControllerTest < ActionController::TestCase
  test 'Submitting keys with mac must work' do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("e0f847427c2a:e0f847427c2a")
    @request.remote_addr = '10.11.12.13'
    post(:create, {:cert => CertMock.new, :format => "txt" })
    assert_response :success
    n = Node.where(:wlan_mac => 'e0f847427c2a').first
    assert n
    assert n.tincs.size == 1
    assert n.tincs.first.cert_data == "abc1234"
    assert n.tincs.first.rip == '10.11.12.13'

  end
  class CertMock
    def read
      "abc1234"
    end
  end
end