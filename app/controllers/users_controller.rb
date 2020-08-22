# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :extension_allowed, only: [:create]

  # GET -> /users/new
  def new
  end

# import excel file and create users
  def create
  	@users = User.imported_users(params[:file]) if @file_error.nil?
    error_handle
  	respond_to do |format|
  		format.js 
  	end
  end

  # list of all users GET -> /users/list
  def list
  	@users = User.all
  end

  private 

  # calculate errors objects
  def error_handle
    @errors = []
    u = @users.map { |us| us.errors.any? }
    @saved_objects = {failed: u.count(true), passed: u.count(false)}
     @users.map do |user|
      if user.errors.any?
       @errors << user.errors[:base]
     else
      user.save
     end
    end
     @errors.flatten
  end

  # validate  uploaded file extension
  def extension_allowed
    begin
      exten = File.extname(params[:file].original_filename)
      raise "file type #{params[:file].original_filename} not allow " unless ['.xls', '.xlsx'].include?(exten)
    rescue Exception => e
      @file_error = e.message
    end
  end  

end
