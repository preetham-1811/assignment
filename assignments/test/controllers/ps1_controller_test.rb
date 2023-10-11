require 'test_helper'

class Ps1ControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_mainpage_path
    assert_response :success
  end

  test "should get ps1" do
    get ps1_ps1_url
    assert_response :success
  end

  # test "should get article" do
  #   get ps1_article_url
  #   assert_response :success
  # end

  test "visit divide by zero page" do
    assert_raises(ZeroDivisionError) do
      get ps1_dbz_url
    end
  end

end
