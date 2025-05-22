require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get main_dashboard_url
    assert_response :success
  end
end
