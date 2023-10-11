require 'test_helper'

class ExamschedulerControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get examscheduler_index_path
  end

  test "redirect to login if not logged in" do
    get examscheduler_index_path
    assert_redirected_to new_user_session_path
  end

  test "redirect to index for students, professors" do
    sign_in users(:one)
    get examscheduler_admin_path
    assert_redirected_to examscheduler_index_path

    sign_in users(:three)
    get examscheduler_admin_path
    assert_redirected_to examscheduler_index_path
  end

  test "access admin pages for admin" do
    sign_in users(:two)
    get examscheduler_admin_path
    assert_response :success
  end

  test "should be able to ban/unban user" do
    sign_in users(:two)
    get examscheduler_ban_users_path, params: { 'id' => '1' }
    assert_select '.table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(3) > a:nth-child(1)', text: 'Unban'

    get examscheduler_ban_users_path, params: { 'id' => '1' }
    assert_select '.table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(3) > a:nth-child(1)', text: 'Ban'
  end

  test "should be able to see recently registered users" do
    sign_in users(:two)
    get examscheduler_manage_users_recently_registered_users_path
    assert_select 'html body div.container table.table tbody tr', 2
  end

  test 'should be able to view stats' do
    sign_in users(:two)
    get examscheduler_user_stats_path
    assert_response :success
    get examscheduler_user_stats_path, params: {"date"=>{"register_month"=>"11", "register_year"=>"2015"}, "controller"=>"examscheduler", "action"=>"view_stats"}
    assert_response :success
  end

  test 'should be able to see my schedule' do
    sign_in users(:one)
    get examscheduler_index_path
    assert_select 'table'
  end

  test 'should be able to see full schedule' do
    sign_in users(:one)
    get examscheduler_fullschedule_path
    assert_select 'table'
  end
end
