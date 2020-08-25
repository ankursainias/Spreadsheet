require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

	fixtures :users
  
  test "should get new" do
    get users_new_url
    assert_response :success
  end

  test "should get users list" do
    get users_list_url
    assert_response :success
  end  

  test "upload xlsx file and process" do
  	file = fixture_file_upload('test/fixtures/files/TaskSampleSheet.xlsx')	
    post users_create_url, xhr: true,  params: { file: file }
    assert_response :success
  end

  test "upload file other than xlsx not acceptable" do
  	file = fixture_file_upload('test/fixtures/files/road.jpeg')	
    post users_create_url, xhr: true,  params: { file: file }
    assert_equal true, flash[:error].present?
  end  

end
