class Schedule < ActiveRecord::Base
	validates :sched, :uniqueness => true
	validate :should_not_less_than_present_day
	validates :applicant_id, :uniqueness => true

	def should_not_less_than_present_day
		errors.add(:sched, "can't be in the past") if
      		sched < Date.today
	end
end
