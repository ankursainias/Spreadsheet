require 'test_helper'

class ImportExcelTest < ActionDispatch::IntegrationTest
  test "import excel data file" do
  		get users_new_url
  		assert_response :success

  		assert_select "form input", 2
  		assert_select '[type=file]', :count => 1
  		assert_select '[type=submit]', :count => 1
  		assert_select 'div[id=imported-data]', :count => 1

  		file = fixture_file_upload('test/fixtures/files/TaskSampleSheet.xlsx')	
  		
  		post users_create_url , xhr: true,  params: { file: file }
  		assert_equal 'text/javascript; charset=utf-8', response.content_type
  		assert_response :success

  		assert_select 'h3', :count => 2
  		assert_select 'h2', :minimum => 0, :maximum => 1
  		assert_select 'table', :count => 1

  end
end
