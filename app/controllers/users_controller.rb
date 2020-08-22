class UsersController < ApplicationController
  before_action :extension_allowed, only: [:create]

  def new
  end

  def create
  	@users = User.imported_users(params[:file]) if @file_error.nil?
    error_handle
  	respond_to do |format|
  		format.js 
  	end
  end

  def list
  	@users = User.all
  end

  private 

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

  def extension_allowed
    begin
      exten = File.extname(params[:file].original_filename)
      raise "file type #{params[:file].original_filename} not allow " unless ['.xls', '.xlsx'].include?(exten)
    rescue Exception => e
      @file_error = e.message
    end
  end  

end
