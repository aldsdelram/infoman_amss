module ApplicantsHelper
	def validate_applicant_identity(applicant)

		matched_db_applicant = []
		boolean_matched = []
		applicant_bday = (applicant["bday(1i)"].to_s+'-'+applicant["bday(2i)"].to_s+'-'+applicant["bday(3i)"].to_s).to_date

		Applicant.all.each do |db_applicant|
			boolean_matched = [db_applicant.id.to_s ,"false", "false", "false"]
			if db_applicant.firstname == applicant[:firstname] &&
				db_applicant.lastname == applicant[:lastname] &&
				applicant_bday == db_applicant.bday

				if applicant[:middlename] != ""
					if db_applicant.middlename == applicant[:middlename]
						boolean_matched[1] = "true"
					end
				else
					boolean_matched[1] = "true"
				end
			end

			if db_applicant.email_address == applicant[:email_address]
				boolean_matched[2] = "true"
			end

			if db_applicant.contact == applicant[:contact]
				boolean_matched[3] = "true"
			end

			if boolean_matched.include? "true"
				matched_db_applicant << boolean_matched
			end
		end

		matched = ""
		matched_db_applicant.each do |print|
			print.each do |data|
				matched += data+"\n"
			end
			matched += "\n"
		end

		return matched_db_applicant
	end

	def get_selected_interviewers_id(interviewers)
		id = []
		interviewers.each do |store|
			id << store.id
		end
		return id
	end


	def get_data_where_status_is(status)
		@tblMonth = '(SELECT 1 AS m UNION SELECT 2 UNION SELECT 3 UNION ' +
       'SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION ' +
       'SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION ' +
       'SELECT 10 UNION SELECT 11 UNION SELECT 12)';

		if status == "All"
    @applicants = Applicant.select('MONTHNAME(STR_TO_DATE(m,\'%m\')) as month,'+
      ' COUNT(lastname) as count')
      .where(['YEAR(created_at) = ? OR lastname IS NULL',
      	Date.today.year])
			.group('m')
			.joins('RIGHT JOIN '+ @tblMonth + 'month ON MONTH(created_at) = month.m'
	   	)
		else
    @applicants = Applicant.select('MONTHNAME(STR_TO_DATE(m,\'%m\')) as month,'+
      ' COUNT(lastname) as count')
      .where(['(status = ? AND YEAR(created_at) = ?) OR lastname IS NULL',
      	status, Date.today.year])
			.group('m')
			.joins('RIGHT JOIN '+ @tblMonth + 'month ON MONTH(created_at) = month.m'
	   	)
		end
	  @applicant_data = {}
	  @applicants.each do |applicant|
	     @applicant_data[applicant.month] = applicant.count
	  end

	  return @applicant_data
	end
end
