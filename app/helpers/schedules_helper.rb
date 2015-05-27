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

	def get_interviewer_grade(schedule)
		case schedule.grade
			when "PS"
				label = "Passed and canceled all other interviews"
			when "FS"
				label = "Failed and canceled all other interviews"
			when "PC"
				label = "Passed and continue"
			when "FC"
				label = "Failed but continue to other interviews"
		end

		return label
	end
end
