# frozen_string_literal: true

class User < ApplicationRecord

	# Validations
	  validates :email_id, allow_blank: false, 
 										  allow_nil: false, 
	 									  format: { with: URI::MailTo::EMAIL_REGEXP }
		
		validates_length_of :email_id,
											  :first_name,
											  :first_name,
											  maximum: 255

		validates :first_name, :last_name, presence: true

		attr_accessor :sheet_error

	HEADER_ROW = 1
	INITAL_ROW = 2	

	def self.import_via_excelsheet(url)
			require 'roo'
			spreadsheet = Roo::Spreadsheet.open(url.path)
			header = spreadsheet.row(HEADER_ROW).map(&:downcase)
			total_sheets =  spreadsheet.sheets
			records = []
			total_sheets.each do |name|
				sheet = spreadsheet.sheet(name)
				   (INITAL_ROW..sheet.last_row).map do |i|
				    row = ([header, sheet.row(i)].transpose).to_h
				    row.merge!(sheet_error: error_message(name, i))
				    records << new(whitelist_attributes(row))
				  end	
		  end
		  spreadsheet.close
		  File.delete(url)
		return records  	
	end


	def self.imported_users(url)
		users = import_via_excelsheet(url)
		saving_records(users)
		users
	end	

	def self.saving_records(users)
    if users.map(&:valid?).all?
      users.each(&:save)
      true
    else
      users.each_with_index do |user, index|
      	msg = user.errors.full_messages.join(', ')
      	if msg.present?
        	user.errors.add :base, "#{user.sheet_error}: #{msg}" 
      	end
      end
      false
    end
	end

	private

	def self.whitelist_attributes(raw_parameters)
		params = ActionController::Parameters.new(raw_parameters)
		params.permit(:first_name, :last_name, :email_id, :sheet_error)
	end


	def self.error_message(name, i)
			"#{name}(#{(i-HEADER_ROW).ordinalize} row)"
	end

									   									
end
