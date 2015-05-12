class Schedule < ActiveRecord::Base
	
	validate :should_not_less_than_present_day
	validates :applicant_id, :uniqueness => true
	validates :sched, :uniqueness => true

	def should_not_less_than_present_day
		errors.add(:sched, "can't be in the past") if
      		self.sched < Date.today
	end
end 
