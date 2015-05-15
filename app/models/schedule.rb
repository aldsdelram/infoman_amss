class Schedule < ActiveRecord::Base
	
	attr_accessor :realNil
	attr_accessor :hasError
	attr_accessor :re_sched
	
	validate :should_not_less_than_present_day
	validate :check_date
	#validates :applicant_id, :uniqueness => true
	validates_uniqueness_of :sched, :scope => :interviewer_id
	validates :sched, :applicant_id, :presence => true, :if => @realNil
	
	def check_date
		if self.hasError
			self.errors.add(:sched, "Invalid date")
		end
	end

	def should_not_less_than_present_day
		if !self.hasError && !self.realNil
			dateNow = DateTime.now.to_s.split('T')
			errors.add(:sched, "can't be in the past") if
				DateTime.parse(self.sched.to_s) <= DateTime.parse(dateNow[0])
		end
	end
end 
