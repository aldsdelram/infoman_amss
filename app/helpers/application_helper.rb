module ApplicationHelper

  def paginate(collection, options = {})
    options[:renderer] ||= SearchPaginationHelper::LinkRenderer
    options[:next_label] ||= '&raquo;'
    options[:previous_label] ||= '&laquo;'
    options[:inner_window]   ||= 2
    options[:outer_window] ||= 1

    will_paginate(collection, options)
  end

  def delete_all_records
  	
  	Rails.application.eager_load!

  	models = ActiveRecord::Base.descendants

  	models.each do |model|
  		count = 0
  		if model.to_s == "Applicant"
  			model.all.each do |applicant|
  				interviewers = applicant.interviewers
  				interviewers.each do |interviewer|
  					interviewer.applicants.delete(applicant)
  				end
  				if File.exists?("#{RAILS_ROOT}/public/images/#{applicant.image_name}") &&
  					!applicant.image_name.nil?
      				File.delete("#{RAILS_ROOT}/public/images/#{applicant.image_name}")
    			end
    			count+=1
    			applicant.destroy
  			end
  		elsif model.to_s == "Admin"
  			model.all.each do |admin|
  				if File.exists?("#{RAILS_ROOT}/public/images/#{admin.image_name}") &&
  					!admin.image_name.nil?
      				File.delete("#{RAILS_ROOT}/public/images/#{admin.image_name}")
    			end
    			count+=1
    			admin.destroy
  			end
  		elsif model.to_s == "Interviewer"
  			model.all.each do |interviewer|
  				if File.exists?("#{RAILS_ROOT}/public/images/#{interviewer.image_name}") &&
  					!interviewer.image_name.nil?
      				File.delete("#{RAILS_ROOT}/public/images/#{interviewer.image_name}")
    			end
    			count+=1
    		 	interviewer.destroy
  			end
  		else
  			count = model.all.count
  			model.delete_all
  		end
  		puts model.to_s+" => "+count.to_s
  	end
  end

end
