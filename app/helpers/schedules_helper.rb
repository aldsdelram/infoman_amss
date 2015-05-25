module SchedulesHelper

	def determine_am_pm(sched_time)
		sched_time_str = ''
		if sched_time[0].to_i >= 12
	       sched_time_str = sched_time[0]+':'+sched_time[1]+':'+sched_time[2]+' PM'
	      if sched_time[0].to_i > 12
	        sched_time[0] = (sched_time[0].to_i-12).to_s
	        sched_time_str = sched_time[0]+':'+sched_time[1]+':'+sched_time[2]+' PM'
	      end
	    else
	      sched_time_str = sched_time[0]+':'+sched_time[1]+':'+sched_time[2]+' AM'
	    end
	    return sched_time_str
	end

	def get_schedule(interviewer, applicant_id)
		schedule = interviewer.schedules.find(:first, :conditions => ["applicant_id = ?", applicant_id])
		return schedule
	end
end
