require 'test_helper'

class MobileInterfaceControllerTest < ActionController::TestCase
  test "should get doPost" do
    get :doPost
    assert_response :success
  end

end
