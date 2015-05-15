module ApplicantsHelper
	def validate_applicant_identity(applicant)
		
		matched_db_applicant = []
		boolean_matched = []
		applicant_bday = applicant["bday(1i)"].to_s+'-'+applicant["bday(2i)"].to_s+'-'+applicant["bday(3i)"].to_date

		Applicant.all.each do |db_applicant|
			boolean_matched = [db_applicant.to_s ,"false", "false", "false", "false"]
			if db_applicant.firstname == applicant[:firstname] &&
				db_applicant.lastname == applicant[:lastname]

				if applicant[:middlename] != ""
					if db_applicant.middlename == applicant[:middlename]
						boolean_matched[0] = "true"
					end
				else
					boolean_matched[1] = "true"
				end

			elsif db_applicant.email_address == applicant[:email_address]
				boolean_matched[2] = "true"
			elsif db_applicant == applicant[:contact]
				boolean_matched[3] = "true"
			elsif applicant_bday == db_applicant.bday
				boolean_matched[4] = "true"
			end
			
			if boolean_matched.inlude? "true"
				matched_db_applicant << boolean_matched
			end
		end

		matched_db_applicant.each do |matched|
			puts matched.id
		end

		raise "Firstname:    "+applicant[:firstname].to_s+
			"\nLastname:     "+applicant[:lastname].to_s+
			"\nMiddlename:   "+applicant[:middlename].to_s+
			"\nBirthday:     "+applicant[:bday].to_s+
			"\nEmailaddress: "+applicant[:email_address].to_s+
			"\nContact:      "+applicant[:contact].to_s

	end	
end
