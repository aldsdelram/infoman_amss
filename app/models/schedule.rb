class Schedule < ActiveRecord::Base
	
	attr_accessor :realNil
	attr_accessor :hasError
	attr_accessor :re_sched
	
	belongs_to :interviewer
	belongs_to :applicant

	$conflict = false

	validate :should_not_less_than_present_day
	validate :check_date
	#validates :applicant_id, :uniqueness => true
	#validate :should_not_conflict
	validates_uniqueness_of :sched_start, :scope => :interviewer_id
	validates :sched_start, :applicant_id, :presence => true, :if => @realNil
	
	def check_date
		if self.hasError
			self.errors.add(:sched_start, "Invalid date")
			self.errors.add(:sched_end, "Invalid date")
		end
	end

	def should_not_less_than_present_day
		if !self.hasError && !self.realNil
			dateNow = DateTime.now.to_s.split('T')
			errors.add(:sched, "can't be in the past") if
				DateTime.parse(self.sched_start.to_s) <= DateTime.parse(dateNow[0])
		end
	end

	def should_not_conflict
		day_event = Schedule.find(:all, :conditions=>["interviewer_id = ? AND YEAR(sched_start) = ? AND DAY(sched_start) = ? AND MONTH(sched_start) = ?",self.interviewer_id, self.sched_start.year, self.sched_start.day, self.sched_start.month])
	end
end 
