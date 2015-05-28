class Schedule < ActiveRecord::Base

	attr_accessor :realNil
	attr_accessor :hasError
	attr_accessor :re_sched
	attr_accessor :det


	belongs_to :interviewer
	belongs_to :applicant
	belongs_to :applicants_interviewers

	validate :check_date
	validate :should_not_less_than_present_day, :if => :resume?
	validate :should_not_conflict_with_other_applicants, :if => :resume?
	validate :should_not_conflict_with_other_interviewers, :if=> :resume?
	validate :hasValue
	#validates :applicant_id, :uniqueness => true
	#validates_uniqueness_of :sched_start, :scope => :interviewer_id


	def check_date
		if self.hasError
			errors.add("", "You entered Invalid date: \n - "+self.interviewer.name)
			# puts "===================CHECKDATE==================="
		elsif Time.at(self.sched_end.to_i) <= Time.at(self.sched_start.to_i)
			errors.add("", "Start time cannot be greater than end time \n - "+self.interviewer.name)
		end
	end

	def should_not_less_than_present_day
		dateNow = DateTime.now.to_s.split('T')
		if DateTime.parse(self.sched_start.to_s) <= DateTime.parse(dateNow[0])
			errors.add("", "Schedule can't be in the past")
			# puts "===================Cant be in the past==================="
		end
	end

	def should_not_conflict_with_other_applicants
		day_event = Schedule.find(:all, :conditions=>["interviewer_id = ?
			AND YEAR(sched_start) = ? AND DAY(sched_start) = ? AND MONTH(sched_start) = ? AND NOT(applicant_id = ?) ",
			self.interviewer_id, self.sched_start.year, self.sched_start.day, self.sched_start.month, self.applicant.id])


		day_event.each do |check_time|
				if  Time.at(self.sched_start.to_i) <= Time.at(check_time.sched_end.to_i) &&
			 		Time.at(self.sched_end.to_i) >= Time.at(check_time.sched_start.to_i)
	 						errors.add("", "Interviewer schedule conflict.")
	 						# puts "===================Conflict with other applicants==================="
			 	end
		end
	end

	def should_not_conflict_with_other_interviewers

		day_event_interviewers = Schedule.where("applicant_id = (?)
			AND YEAR(sched_start) = (?) AND DAY(sched_start) = (?) AND MONTH(sched_start) = (?) AND NOT(interviewer_id = ?)",
			 self.applicant_id, self.sched_start.year, self.sched_start.day, self.sched_start.month, self.interviewer.id)

		conflict_interviewers = ""
		day_event_interviewers.each do |schedule|
			puts schedule.interviewer.name+"-"+Time.at(self.sched_start.to_i).to_s+"\n"+Time.at(schedule.sched_end.to_i).to_s
			if Time.at(self.sched_start.to_i) <= Time.at(schedule.sched_end.to_i) &&
			 Time.at(self.sched_end.to_i) >= Time.at(schedule.sched_start.to_i)
				conflict_interviewers += (" - "+schedule.interviewer.name+"\n")
				# puts "===================Conflict with other interviewers==================="
			end
		end

		if conflict_interviewers != ""
			errors.add("", "Conflict in schedule of "+self.interviewer.name+ " with the following schedules:\n"+
				conflict_interviewers)
		end
	end

	def resume?
		if @det == true
			false
		else
			!@hasError && !@realNil
		end
	end

	def hasValue
		if @realNil
			errors.add("", "Schedule Cant be blank: \n - "+self.interviewer.name)
			# puts "===================Cant be blank==================="
		end
	end
end
