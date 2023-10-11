require 'test_helper'

class Ps2ControllerTest < ActionDispatch::IntegrationTest
  test 'should get quotation' do
    get ps2_quotations_url
    get ps2_quotations_url, params: { 'sort_by': 'date'}
    assert_response :success
  end

  test 'Create new quotation' do
    post ps2_quotations_url, params: { 'quotation' => {'author_name' => 'me', 'quote' => 'my quote'}, 'new_category' => {'id' => 'my cat'}, 'commit' => 'Create' }
    # assert_response :success

    post ps2_quotations_url, params: { 'quotation' => {'author_name' => 'ssd', 'category' => 'sad', 'quote' => 'dsfsdf'}, 'new_category' => {'id' => ''}, 'commit' => 'Create' }
    # assert_response :success
    assert_select 'html body div.container div.container-fluid div.row div.col-md-10.col-12 ul li a', 4
  end

  test 'Kill quotes' do
    get ps2_quotations_url, params: { 'id' => '1' }
    assert_select 'html body div.container div.container-fluid div.row div.col-md-10.col-12 ul li', 1
    get ps2_quotations_url, params: { 'id' => '2' }
    assert_select 'html body div.container div.container-fluid div.row div.col-md-10.col-12 ul li', 0
  end

  test 'Erase my personalisation' do
    get ps2_quotations_url, params: { 'clear' => 'true' }
    assert_response :success
  end

  test 'Search quotations' do
    get ps2_quotationssearch_url, params: { 'search' => 'life', 'commit' => 'Search' }
    assert_select 'html body div.container div.container-fluid ul li', 1
  end

  test 'import xml' do
    get '/ps2/importxml', params: { 'page_link' => 'www.badurl.com', 'commit' => 'Import'}
    assert_redirected_to ps2_quotations_url
    assert_equal "Not a valid url", flash[:alert]

    get '/ps2/importxml', params: { 'page_link' => 'https://web2.cs.ait.ac.th/ps2/quotations.xml', 'commit' => 'Import'}
    get ps2_quotations_url
    assert_select('html body div.container div.container-fluid ul li', 2...)
  end

end
