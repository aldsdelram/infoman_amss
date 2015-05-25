class Schedule < ActiveRecord::Base
	
	attr_accessor :realNil
	attr_accessor :hasError
	attr_accessor :re_sched
	
	belongs_to :interviewer
	belongs_to :applicant

	validate :check_date
	validate :should_not_less_than_present_day, :if => :resume?
	validate :should_not_conflict_with_other_applicants, :if => :resume?
	validate :should_not_conflict_with_other_interviewers, :if=> :resume?

	validates :sched_start, :applicant_id, :presence => true, :if => @realNil
	
	#validates :applicant_id, :uniqueness => true
	#validates_uniqueness_of :sched_start, :scope => :interviewer_id
	
	def check_date
		if self.hasError
			self.errors.add("", "Invalid date")
		end
	end

	def should_not_less_than_present_day
		dateNow = DateTime.now.to_s.split('T')
		if DateTime.parse(self.sched_start.to_s) <= DateTime.parse(dateNow[0])
			errors.add("", "Schedule can't be in the past")
		end
	end

	def should_not_conflict_with_other_applicants
		day_event = Schedule.find(:all, :conditions=>["interviewer_id = ? 
			AND YEAR(sched_start) = ? AND DAY(sched_start) = ? AND MONTH(sched_start) = ?",
			self.interviewer_id, self.sched_start.year, self.sched_start.day, self.sched_start.month])

		day_event.each do |check_time|
			errors.add("", "Interviewer schedule conflict.") if 
				Time.at(self.sched_start.to_i) <= Time.at(check_time.sched_end.to_i)
		end
	end

	def should_not_conflict_with_other_interviewers

		day_event_interviewers = Schedule.where("applicant_id = (?) 
			AND YEAR(sched_start) = (?) AND DAY(sched_start) = (?) AND MONTH(sched_start) = (?)",
			 self.applicant_id, self.sched_start.year, self.sched_start.day, self.sched_start.month).all

		conflict_interviewers = ""
		day_event_interviewers.each do |schedule|
			if Time.at(self.sched_start.to_i) <= Time.at(schedule.sched_end.to_i)
				conflict_interviewers += (" - "+schedule.interviewer.name+"\n")
			end
		end
		
		if conflict_interviewers != ""
			errors.add("", "Cannot complete request: Conflict in interview schedule with:\n"+conflict_interviewers)
		end
	end

	def resume?
		!@hasError && !@realNil
	end
end 
