require 'test_helper'

class Api::V1::OutagesControllerTest < ActionController::TestCase
  
  # This should return the minimal set of attributes required to create a valid
  # Outage. As you add validations to Outage, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OutagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end
  
  setup do
    ::V1::Outage.any_instance.stubs(:scheduler_perform)
    @outage = ::V1::Outage.create! valid_attributes
  end

  should "index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:outages)
  end

  should "get new" do
    get :new
    assert_response :success
  end

  should "create outage" do
    assert_difference('Outage.count') do
      post :create, outage: {  }
    end

    assert_redirected_to api_v1_outage_path(assigns(:outage))
  end

  should "show outage" do
    get :show, id: @outage
    assert_response :success
  end

  should "get edit" do
    get :edit, id: @outage
    assert_response :success
  end

  should "update outage" do
    put :update, id: @outage, outage: {  }
    assert_redirected_to api_v1_outage_path(assigns(:outage))
  end

  should "destroy outage" do
    assert_difference('Outage.count', -1) do
      delete :destroy, id: @outage
    end

    assert_redirected_to api_v1_outages_path
  end
end
