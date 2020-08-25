require 'test_helper'

class UserTest < ActiveSupport::TestCase

	fixtures :users

	test "should not save user without first name" do
	  object = User.new(last_name: users(:u1).last_name , email_id: users(:u1).email_id )
	  assert_not object.save, 
	  									(I18n.t 'model.user.validation.presence', attribute: 'first name')
	end

	test "should not save user without last name" do
	  object = User.new(first_name:  users(:u1).first_name, email_id: users(:u1).email_id)
	  assert_not object.save, 
	  									(I18n.t 'model.user.validation.presence', attribute: 'last name')
	end

	test "should not save user without email id" do
	  object = User.new(first_name: users(:u1).first_name, last_name: users(:u1).last_name)
	  assert_not object.save, 
	  										(I18n.t 'model.user.validation.presence', attribute: 'email id')
	end

	test "should not save user without valid email id" do
	  object = User.new(first_name: users(:u1).first_name, last_name: users(:u1).last_name, 
	  									email_id: 'test@')
	  assert_no_match URI::MailTo::EMAIL_REGEXP, object.email_id, 
	  											(I18n.t 'model.user.validation.presence', attribute: 'valid email id')
	end

end
