require 'test_helper'

class NodeRegistrationsControllerTest < ActionController::TestCase
  setup do
    @node_registration = node_registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:node_registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create node_registration" do
    assert_difference('NodeRegistration.count') do
      post :create, :node_registration => @node_registration.attributes
    end

    assert_redirected_to node_registration_path(assigns(:node_registration))
  end

  test "should show node_registration" do
    get :show, :id => @node_registration.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @node_registration.to_param
    assert_response :success
  end

  test "should update node_registration" do
    put :update, :id => @node_registration.to_param, :node_registration => @node_registration.attributes
    assert_redirected_to node_registration_path(assigns(:node_registration))
  end

  test "should destroy node_registration" do
    assert_difference('NodeRegistration.count', -1) do
      delete :destroy, :id => @node_registration.to_param
    end

    assert_redirected_to node_registrations_path
  end
end
